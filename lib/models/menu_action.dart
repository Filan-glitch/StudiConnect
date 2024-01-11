/// This library contains the [MenuAction] class.
///
/// {@category MODELS}
library models.menu_action;

import 'package:flutter/material.dart';

/// Represents a menu action.
///
/// This class is used to define a menu action with a title, an icon, and a function to be executed when the action is tapped.
class MenuAction {

  /// The title of the menu action.
  final String title;

  /// The icon of the menu action.
  final IconData icon;

  /// The function to be executed when the menu action is tapped.
  final Function onTap;

  /// Creates a [MenuAction].
  ///
  /// The [title], [icon], and [onTap] parameters must not be null.
  MenuAction({required this.title, required this.icon, required this.onTap});
}