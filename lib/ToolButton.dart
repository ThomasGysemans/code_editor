import 'package:flutter/material.dart';

/// A button under the navigation bar to help the user write code.
class ToolButton {
  /// The function to execute when pressing the tool button.
  void Function() press;

  /// The icon to display on that button in case there is no Unicode character for it.
  IconData? icon;

  /// Simple Unicode characters to represent what the button's going to do.
  /// If there is not character able to describe its role, then use `icon`.
  String? symbol;

  ToolButton({
    required this.press,
    this.icon,
    this.symbol,
  });
}
