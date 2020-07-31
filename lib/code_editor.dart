library code_editor;

import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

part 'Theme.dart';
part 'TextUtils.dart';
part 'ToolButton.dart';
part 'EditorModel.dart';
part 'EditorModelStyleOptions.dart';

class CodeEditor extends StatelessWidget {
  final EditorModel model;
  final Function(String language, String value) onSubmit;
  CodeEditor({
    Key key,

    /// the EditorModel in order to control the editor
    @required this.model,

    /// onSubmit function to execute when the user saves changes in a file
    @required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => model,
      child: Container(
        margin: EdgeInsets.only(bottom: 50),
        child: Column(
          children: <Widget>[
            _NavBarFiles(),
            _ContentEditor(
              // we have to pass a initalCode because we must initialize
              // the inital text of the text field in initState()
              // through the controller
              initialCode: model.code[model.currentLanguage],
              onSubmit: this.onSubmit ?? (String language, String value) {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentEditor extends StatefulWidget {
  final String initialCode;
  final Function onSubmit;
  _ContentEditor({
    Key key,
    @required this.initialCode,
    @required this.onSubmit,
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

    /// initialize the controller for the text field
    editingController = TextEditingController(text: widget.initialCode);
    newValue = widget.initialCode; // if there are no changes
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  /// set the cursor at the end of the editableText
  void placeCursorAtTheEnd() {
    editingController.selection = TextSelection.fromPosition(
      TextPosition(offset: editingController.text.length),
    );
  }

  /// place the cursor where wanted
  /// [pos] places the cursor in the text field
  void placeCursor(int pos) {
    try {
      editingController.selection = TextSelection.fromPosition(
        TextPosition(offset: pos),
      );
    } catch (e) {
      throw "code_editor package : placeCursor(int pos), pos is not valid.";
    }
  }

  /// creates the text field
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
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            letterSpacing: 1.25,
            fontWeight: FontWeight.w500,
          ),
          focusNode: focusNode,
          controller: editingController,
          onChanged: (String v) => newValue = v,
          key: editableTextKey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    EditorModel model = context.watch<EditorModel>();
    String language = model.currentLanguage;
    String code = model.code[language];

    // when we change the file in the navbar, the code in the text field
    // isn't updated, so we update it here,
    // with newValue = code if the user does not change the value
    // in the text field
    editingController = TextEditingController(text: code);
    newValue = code;

    EditorModelStyleOptions opt = model.styleOptions;

    /// create the edit button and the save button ("OK") with a
    /// particual function onPress to execute
    Positioned editButton(String name, Function press) {
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
    }

    /// add a particular string where the cursor is in the text field
    /// [str] the string to insert
    /// [diff] by default, the the cursor is placed after the string placed, but you can change this (Exemple: -1 for "" placed)
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

    /// create the toolbar
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

    // we place the cursor in the end of the text field
    if (model.isEditing) {
      placeCursorAtTheEnd();
    }

    // we toggle the editor and the text field
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
                model.changeCodeOfLanguage(language, newValue);
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
                padding: opt.padding,
                child: SingleChildScrollView(
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
    int index = model.index;

    EditorModelStyleOptions opt = model.styleOptions;

    TextUtils showFilename(String name, bool isSelected) {
      return TextUtils(
        name,
        color: isSelected
            ? opt.editorFilenameColor
            : opt.editorFilenameColor.withOpacity(0.5),
      );
    }

    return Container(
      width: double.infinity,
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        color: opt.editorColor,
        border: Border(bottom: BorderSide(color: opt.editorBorderColor)),
      ),
      child: Row(
        children: <Widget>[
          GestureDetector(
            child: showFilename("index.html", index == 1),
            onTap: () {
              model.changeIndexTo(1);
            },
          ),
          SizedBox(width: 15),
          GestureDetector(
            child: showFilename("style.css", index == 2),
            onTap: () {
              model.changeIndexTo(2);
            },
          ),
          SizedBox(width: 15),
          GestureDetector(
            child: showFilename("app.js", index == 3),
            onTap: () {
              model.changeIndexTo(3);
            },
          ),
        ],
      ),
    );
  }
}
