library code_editor;

import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'TextUtils.dart';
import 'ToolButton.dart';

part 'EditorModel.dart';
part 'EditorModelStyleOptions.dart';
part 'Theme.dart';

/// Creates a code editor that helps users to write and read code.
///
/// In order to use it, you must define :
/// * [model] an EditorModel, to control the editor, its content and its files
/// * [onSubmit] a Function(String language, String value) executed when the user submits changes in a file.
class CodeEditor extends StatelessWidget {
  /// The EditorModel in order to control the editor.
  ///
  /// This argument is @required.
  final EditorModel model;

  /// onSubmit function to execute when the user saves changes in a file.
  /// This is a function that takes [language] and [value] as arguments.
  ///
  /// * [language] is the language of the file edited by the user.
  /// * [value] is the content of the file.
  final Function(String language, String value) onSubmit;

  /// You can disable the edit button (it won't show up at all) just like this :
  ///
  /// ```
  /// CodeEditor(
  ///   model: model, // my EditorModel()
  ///   edit: false, // disable the edit button
  /// )
  /// ```
  ///
  /// By default, the value is true.
  final bool edit;

  CodeEditor({
    Key key,
    @required this.model,
    this.onSubmit,
    this.edit = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => model,
      child: Column(
        children: <Widget>[
          _NavBarFiles(),
          _ContentEditor(
            // we have to pass a initalCode because we must initialize
            // the inital text of the text field in initState()
            // through the controller
            initialCode: model.getCodeWithIndex(0),
            onSubmit: this.onSubmit ?? (String language, String value) {},
            edit: edit,
          ),
        ],
      ),
    );
  }
}

class _ContentEditor extends StatefulWidget {
  final String initialCode;
  final Function onSubmit;
  final bool edit;
  _ContentEditor({
    Key key,
    @required this.initialCode,
    @required this.onSubmit,
    @required this.edit,
  }) : super(key: key);

  @override
  __ContentEditorState createState() => __ContentEditorState();
}

class __ContentEditorState extends State<_ContentEditor> {
  GlobalKey editableTextKey = GlobalKey();
  TextEditingController editingController;
  String newValue;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    /// Initialize the controller for the text field.
    editingController = TextEditingController(text: widget.initialCode);
    newValue = widget.initialCode; // if there are no changes
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  /// Set the cursor at the end of the editableText.
  void placeCursorAtTheEnd() {
    editingController.selection = TextSelection.fromPosition(
      TextPosition(offset: editingController.text.length),
    );
  }

  /// Place the cursor where wanted.
  ///
  /// [pos] places the cursor in the text field
  void placeCursor(int pos) {
    try {
      editingController.selection = TextSelection.fromPosition(
        TextPosition(offset: pos),
      );
    } catch (e) {
      throw Exception(
          "code_editor package : placeCursor(int pos), pos is not valid.");
    }
  }

  @override
  Widget build(BuildContext context) {
    EditorModel model = context.watch<EditorModel>();
    String language = model.currentLanguage;
    int position = model.position;
    String code = model.getCodeWithIndex(position);

    // When we change the file in the navbar, the code in the text field
    // isn't updated, so we update it here.
    //
    // With newValue = code if the user does not change the value
    // in the text field
    editingController = TextEditingController(text: code);
    newValue = code;

    EditorModelStyleOptions opt = model.styleOptions;

    /// Creates the text field.
    SingleChildScrollView buildEditableText() {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            right: 10,
            left: 10,
            top: 10,
            bottom: 50,
          ),
          child: EditableText(
            autofocus: true,
            maxLines: null,
            backgroundCursorColor: Colors.amber,
            cursorColor: Colors.green,
            style: opt.textStyleOfTextField,
            focusNode: focusNode,
            controller: editingController,
            onChanged: (String v) => newValue = v,
            key: editableTextKey,
          ),
        ),
      );
    }

    /// Creates the edit button and the save button ("OK") with a
    /// particual function [press] to execute.
    ///
    /// This button won't appear if `edit = false`.
    Widget editButton(String name, Function press) {
      if (widget.edit != false) {
        return Positioned(
          bottom: opt.editButtonPosBottom,
          right: opt.editButtonPosRight,
          top: opt.editButtonPosTop,
          left: opt.editButtonPosLeft,
          child: RaisedButton(
            onPressed: press,
            color: opt.editButtonColor,
            child: TextUtils(
              name,
              color: opt.editButtonTextColor,
            ),
          ),
        );
      } else {
        return SizedBox.shrink();
      }
    }

    /// Add a particular string where the cursor is in the text field.
    /// * [str] the string to insert
    /// * [diff] by default, the the cursor is placed after the string placed, but you can change this (Exemple: -1 for "" placed)
    void insertIntoTextField(String str, {int diff = 0}) {
      // get the position of the cursor in the text field
      int pos = editingController.selection.baseOffset;
      // get the current text of the text field
      String baseText = editingController.text;
      // get the string : 0 -> pos of the current text and add the wanted string
      String begin = baseText.substring(0, pos) + str;
      // if we are already in the end of the string
      if (baseText.length == pos) {
        editingController.text = begin;
      } else {
        // get the end of the string and update the text of the text field
        String end = baseText.substring(pos, baseText.length);
        editingController.text = begin + end;
      }
      // if we don't do this, when we click on a toolbutton, the method
      // onChanged() isn't called, so newValue isn't updated
      newValue = editingController.text;
      placeCursor(pos + str.length + diff);
    }

    /// Creates the toolbar.
    Widget toolBar() {
      List<ToolButton> toolButtons = [
        ToolButton(
          press: () => insertIntoTextField("\t"),
          icon: FontAwesomeIcons.indent,
        ),
        ToolButton(
          press: () => insertIntoTextField("<"),
          icon: FontAwesomeIcons.chevronLeft,
        ),
        ToolButton(
          press: () => insertIntoTextField(">"),
          icon: FontAwesomeIcons.chevronRight,
        ),
        ToolButton(
          press: () => insertIntoTextField('""', diff: -1),
          icon: FontAwesomeIcons.quoteLeft,
        ),
        ToolButton(
          press: () => insertIntoTextField(":"),
          symbol: ":",
        ),
        ToolButton(
          press: () => insertIntoTextField(";"),
          symbol: ";",
        ),
        ToolButton(
          press: () => insertIntoTextField('()', diff: -1),
          symbol: "()",
        ),
        ToolButton(
          press: () => insertIntoTextField('{}', diff: -1),
          symbol: "{}",
        ),
        ToolButton(
          press: () => insertIntoTextField('[]', diff: -1),
          symbol: "[]",
        ),
        ToolButton(
          press: () => insertIntoTextField("-"),
          icon: FontAwesomeIcons.minus,
        ),
        ToolButton(
          press: () => insertIntoTextField("="),
          icon: FontAwesomeIcons.equals,
        ),
        ToolButton(
          press: () => insertIntoTextField("+"),
          icon: FontAwesomeIcons.plus,
        ),
        ToolButton(
          press: () => insertIntoTextField("/"),
          icon: FontAwesomeIcons.divide,
        ),
        ToolButton(
          press: () => insertIntoTextField("*"),
          icon: FontAwesomeIcons.times,
        ),
      ];

      return Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: opt.editorColor,
          border: Border(bottom: BorderSide(color: opt.editorBorderColor)),
        ),
        child: ListView.builder(
          padding: EdgeInsets.only(left: 15, top: 8, bottom: 8),
          itemCount: toolButtons.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, int index) {
            final ToolButton btn = toolButtons[index];

            return Container(
              width: 55,
              margin: EdgeInsets.only(right: 15), // == padding right above
              child: FlatButton(
                color: opt.editorToolButtonColor,
                onPressed: btn.press,
                child: btn.icon == null
                    ? TextUtils(
                        btn.symbol,
                        color: opt.editorToolButtonTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "monospace",
                      )
                    : FaIcon(
                        btn.icon,
                        color: opt.editorToolButtonTextColor,
                        size: 15,
                      ),
              ),
            );
          },
        ),
      );
    }

    // We place the cursor in the end of the text field.
    if (model.isEditing) {
      placeCursorAtTheEnd();
    }

    // We toggle the editor and the text field.
    return model.isEditing
        ? Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  // the toolbar
                  toolBar(),
                  // Container of the EditableText
                  Container(
                    width: double.infinity,
                    height: opt.heightOfContainer,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: opt.editorBorderColor.withOpacity(0.4),
                        ),
                      ),
                    ),
                    child: buildEditableText(),
                  ),
                ],
              ),
              // The OK button
              editButton("OK", () {
                model.updateCodeOfIndex(position, newValue);
                model.toggleEditing();
                widget.onSubmit(language, newValue);
              }),
            ],
          )
        : Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: opt.heightOfContainer,
                color: opt.editorColor,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: opt.padding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        HighlightView(
                          code,
                          language: language,
                          theme: opt.theme,
                          tabSize: opt.tabSize,
                          textStyle: TextStyle(
                            fontFamily: opt.fontFamily,
                            letterSpacing: opt.letterSpacing,
                            fontSize: opt.fontSize,
                            height: opt.lineHeight, // line-height
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              editButton(opt.editButtonName, () {
                model.toggleEditing();
              }),
            ],
          );
  }
}

class _NavBarFiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EditorModel model = context.watch<EditorModel>();
    EditorModelStyleOptions opt = model.styleOptions;

    /// The filename in green.
    TextUtils showFilename(String name, bool isSelected) {
      return TextUtils(
        name,
        fontSize: opt.fontSizeOfFilename,
        color: isSelected
            ? opt.editorFilenameColor
            : opt.editorFilenameColor.withOpacity(0.5),
      );
    }

    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: opt.editorColor,
        border: Border(bottom: BorderSide(color: opt.editorBorderColor)),
      ),
      child: ListView.builder(
        padding: EdgeInsets.only(left: 15),
        itemCount: model.numberOfFiles,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, int index) {
          final FileEditor file = model.getFileWithIndex(index);

          return Container(
            margin: EdgeInsets.only(right: 15),
            child: Center(
              child: GestureDetector(
                // Checks if the position of the navbar is the current file.
                child: showFilename(file.name, model.position == index),
                onTap: () {
                  model.changeIndexTo(index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
