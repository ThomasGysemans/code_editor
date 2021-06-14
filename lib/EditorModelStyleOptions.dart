part of code_editor;

/// Set the style of CodeEditor.
/// You have to use it in EditorModel() just like this :
/// ```
/// EditorModel model = new EditorModel(
///   files, // My files...
///   styleOptions: new EditorModelStyleOptions(
///     fontSize: 13, // Example
///   ),
/// );
/// ```
/// An EditorModel instance has the default values of EditorModelStyleOptions.
class EditorModelStyleOptions {
  /// Set the padding of the file's content. By default `15.0`.
  final EdgeInsets padding;

  /// Set the height of the container. By default `300`.
  final double heightOfContainer;

  /// Set the theme of the syntax. code_editor has its own theme.
  /// You can create your own or use others themes by looking at :
  /// `import 'package:flutter_highlight/themes/'`.
  final Map<String, TextStyle> theme;

  /// Set the font family of the entire editor. By default `"monospace"`.
  final String fontFamily;

  /// Set the letter spacing property of the text. By default `null`.
  final double? letterSpacing;

  /// Set the fontSize of the file's content. By default `15`.
  final double fontSize;

  /// Set the height (line-height in CSS) property of the text. By default `1.6`.
  final double lineHeight;

  /// Set the size of the tabulation. By default `2`. Do not use a too big number.
  final int tabSize;

  /// Set the background color of the editor. By default `Color(0xff2E3152)`.
  final Color editorColor;

  /// Set the color of the borders between the navigation bar and the content.
  /// By default `Color(0xFF3E416E)`.
  final Color editorBorderColor;

  /// Set the color of the file name in the navigation bar. By default `Color(0xFF6CD07A)`.
  final Color editorFilenameColor;

  /// Set the color property of the edit button. By default `Color(0xFF4650c7)`.
  final Color editorToolButtonColor;

  /// Set the color of the edit button's text. By default `Color(0xFF4650c7)`.
  final Color editorToolButtonTextColor;

  /// Set the font size of the file's name in the navigation bar.
  final double? fontSizeOfFilename;

  /// Set the textStyle of the text field. By default :
  /// ```
  /// TextStyle(
  ///   color: Colors.black87,
  ///   fontSize: 16,
  ///   letterSpacing: 1.25,
  ///   fontWeight: FontWeight.w500,
  /// )
  /// ```
  final TextStyle textStyleOfTextField;

  /// The background color of the button "Edit".
  /// By default `Color(0xFFEEEEEE)`.
  final Color editButtonBackgroundColor;

  /// The text color fo the button "Edit".
  /// By default `Colors.black`.
  final Color editButtonTextColor;

  /// The name of the "Edit" button.
  /// By default `Edit`.
  final String editButtonName;

  final ToolbarOptions toolbarOptions;
  final bool placeCursorAtTheEndOnEdit;

  static const Color defaultColorEditor = Color(0xff2E3152);
  static const Color defaultColorBorder = Color(0xFF3E416E);
  static const Color defaultColorFileName = Color(0xFF6CD07A);
  static const Color defaultToolButtonColor = Color(0xFF4650c7);
  static const Color defaultEditBackgroundColor = Color(0xFFEEEEEE);

  EditorModelStyleOptions(
      {this.padding = const EdgeInsets.all(15.0),
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
      this.editButtonBackgroundColor = defaultEditBackgroundColor,
      this.editButtonTextColor = Colors.black,
      this.editButtonName = "Edit",
      this.fontSizeOfFilename,
      this.textStyleOfTextField = const TextStyle(
        color: Colors.black87,
        fontSize: 16,
        letterSpacing: 1.25,
        fontWeight: FontWeight.w500,
      ),
      this.toolbarOptions = const ToolbarOptions(),
      this.placeCursorAtTheEndOnEdit = true});

  double? editButtonPosTop; // minimum of 50 because of the toolbar
  double? editButtonPosLeft;
  double? editButtonPosBottom = 10;
  double? editButtonPosRight = 15;

  /// You can change the position of the button "Edit" / "OK".
  /// By default, `bottom: 10`, `right: 15`.
  /// Minimum of [top] is 50, `if top < 50 => top = 50` automatically
  /// because of the navigation bar height.
  void defineEditButtonPosition({
    required top,
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
