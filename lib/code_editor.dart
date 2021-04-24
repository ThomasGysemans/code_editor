library code_editor;

import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'ToolButton.dart';

part 'EditorModel.dart';
part 'FileEditor.dart';
part 'EditorModelStyleOptions.dart';
part 'Theme.dart';

/// Creates a code editor that helps users to write and read code.
///
/// In order to use it, you must define :
/// * [model] an EditorModel, to control the editor, its content and its files
/// * [onSubmit] a Function(String language, String value) executed when the user submits changes in a file.
class CodeEditor extends StatefulWidget {
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

  /// You can disable the navigation bar like this :
  ///
  /// ```
  /// CodeEditor(
  ///   model: model, // my EditorModel()
  ///   disableNavigationbar: true, // hide the navigation bar
  /// )
  /// ```
  ///
  /// By default, the value is `false`.
  ///
  /// WARNING : if you set the value to true, only the first
  /// file will be displayed in the editor because
  /// it's not possible to switch betweens other files without the navigation bar.
  final bool disableNavigationbar;

  CodeEditor({
    Key key,
    this.model,
    this.onSubmit,
    this.edit = true,
    this.disableNavigationbar = false,
  }) : super(key: key);

  @override
  _CodeEditorState createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  /// Creates the unique key of the text field.
  GlobalKey editableTextKey = GlobalKey();

  /// We need it to control the content of the text field.
  TextEditingController editingController;

  /// The new content of a file when the user is editing one.
  String newValue;

  /// The text field wants a focus node.
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    /// Initialize the controller for the text field.
    editingController = TextEditingController(text: "");
    newValue = ""; // if there are no changes
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
      throw Exception("code_editor : placeCursor(int pos), pos is not valid.");
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Gets the model from the parent widget.
    EditorModel model = widget.model;

    if (model == null) {
      model = new EditorModel(files: []);
    }

    /// Gets the style options from the parent widget.
    EditorModelStyleOptions opt = model.styleOptions;

    String language = model.currentLanguage;

    /// Which file in the list of file ?
    int position = model.position;

    /// The content of the file where position corresponds to the list of file.
    String code = model.getCodeWithIndex(position);

    bool disableNavigationbar = widget.disableNavigationbar;

    // When we change the file in the navbar, the code in the text field
    // isn't updated, so we update it here.
    //
    // With newValue = code if the user does not change the value
    // in the text field
    editingController = TextEditingController(text: code);
    newValue = code;

    /// The filename in green.
    Text showFilename(String name, bool isSelected) {
      return Text(
        name,
        style: TextStyle(
          fontFamily: "monospace",
          letterSpacing: 1.0,
          fontWeight: FontWeight.normal,
          fontSize: opt.fontSizeOfFilename,
          color: isSelected
              ? opt.editorFilenameColor
              : opt.editorFilenameColor.withOpacity(0.5),
        ),
      );
    }

    /// Build the navigation bar.
    Container buildNavbar() {
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
                    setState(() {
                      model.changeIndexTo(index);
                    });
                  },
                ),
              ),
            );
          },
        ),
      );
    }

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
          child: TextField(
            decoration: InputDecoration(border: InputBorder.none),
            autofocus: true,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: opt.textStyleOfTextField,
            focusNode: focusNode,
            controller: editingController,
            onChanged: (String v) => newValue = v,
            key: editableTextKey,
            toolbarOptions: model.styleOptions.toolbarOptions,
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
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: opt.editButtonBackgroundColor,
            ),
            onPressed: press,
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: "monospace",
                fontWeight: FontWeight.normal,
                color: opt.editButtonTextColor,
              ),
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
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: opt.editorToolButtonColor,
                ),
                onPressed: btn.press,
                child: btn.icon == null
                    ? Text(
                        btn.symbol,
                        style: TextStyle(
                          color: opt.editorToolButtonTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: "monospace",
                        ),
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
    if (model.isEditing && model.styleOptions.placeCursorAtTheEndOnEdit) {
      placeCursorAtTheEnd();
    }

    /// We toggle the editor and the text field.
    Widget buildContentEditor() {
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
                  setState(() {
                    model.updateCodeOfIndex(position, newValue);
                    model.toggleEditing();
                    if (widget.onSubmit != null) {
                      widget.onSubmit(language, newValue);
                    }
                  });
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
                            code ?? "code is null",
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
                  setState(() {
                    model.toggleEditing();
                  });
                }),
              ],
            );
    }

    return Column(
      children: <Widget>[
        disableNavigationbar ? SizedBox.shrink() : buildNavbar(),
        buildContentEditor(),
      ],
    );
  }
}
