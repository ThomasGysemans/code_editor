part of code_editor;

/// helper for Text widget
class TextUtils extends Text {
  TextUtils(
    String data, {
    Color color: Colors.black,
    double fontSize: 16.0,
    FontWeight fontWeight: FontWeight.normal,
    double letterSpacing: 1.0,
    TextAlign textAlign: TextAlign.left,
    String fontFamily = "monospace",
  }) : super(data,
            textAlign: textAlign,
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
              letterSpacing: letterSpacing,
              fontFamily: fontFamily,
            ));
}
