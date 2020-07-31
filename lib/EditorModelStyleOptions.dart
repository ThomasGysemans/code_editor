part of code_editor;

/// set the style of code_editor
class EditorModelStyleOptions {
  final EdgeInsets padding;
  final double heightOfContainer;
  final Map<String, TextStyle> theme;
  final String fontFamily;
  final double letterSpacing;
  final double fontSize;
  final double lineHeight;
  final int tabSize;
  final Color editorColor;
  final Color editorBorderColor;
  final Color editorFilenameColor;
  final Color editorToolButtonColor;
  final Color editorToolButtonTextColor;

  static const Color defaultColorEditor = Color(0xff2E3152);
  static const Color defaultColorBorder = Color(0xFF3E416E);
  static const Color defaultColorFileName = Color(0xFF6CD07A);
  static const Color defaultToolButtonColor = Color(0xFF4650c7);

  EditorModelStyleOptions({
    this.padding = const EdgeInsets.all(15.0),
    this.heightOfContainer = 300,
    this.theme = myTheme,
    this.fontFamily = "monospace",
    this.letterSpacing,
    this.fontSize = 15,
    this.lineHeight = 1.6,
    this.tabSize = 2,
    this.editorColor = defaultColorEditor,
    this.editorBorderColor = defaultColorBorder,
    this.editorFilenameColor = defaultColorFileName,
    this.editorToolButtonColor = defaultToolButtonColor,
    this.editorToolButtonTextColor = Colors.white,
  });

  Color editButtonColor;
  Color editButtonTextColor = Colors.black;
  String editButtonName = "Edit";

  /// define the styles of the edit button
  void defineEditButtonProperties({
    color,
    textColor,
    text,
  }) {
    this.editButtonColor = color ?? editButtonColor;
    this.editButtonTextColor = textColor;
    this.editButtonName = text ?? editButtonName;
  }

  double editButtonPosTop; // minimum of 50 because of the toolbar
  double editButtonPosLeft;
  double editButtonPosBottom = 10;
  double editButtonPosRight = 15;

  /// you can change the position of the button "Edit" or "OK"
  /// by default, bottom: 10, right: 15
  /// minimum of [top] is 50, if top < 50 => top = 50 automatically
  void defineEditButtonPosition({
    top,
    left,
    bottom,
    right,
  }) {
    this.editButtonPosTop = top < 50 ? 50 : top;
    this.editButtonPosLeft = left;
    this.editButtonPosBottom = bottom;
    this.editButtonPosRight = right;
  }
}
