part of code_editor;

class ToolButton {
  Function press;
  IconData icon;
  String symbol;

  ToolButton({
    @required this.press,
    this.icon,
    this.symbol,
  });
}
