import 'package:flutter/material.dart';

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
