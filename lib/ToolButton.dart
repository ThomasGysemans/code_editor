import 'package:flutter/material.dart';

/// A button under the navigation bar to help the user write code.
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
