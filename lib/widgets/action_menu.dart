import 'dart:ui';
import 'package:flutter/material.dart';

/// A widget that displays a menu of actions.
///
/// This widget is a stateless widget that takes a list of child widgets
/// and a title as input and displays them in a menu with a blurred background.
///
/// The [children] parameter is required and should contain the list of widgets
/// that will be displayed in the menu.
///
/// The [title] parameter is optional and defaults to "Aktionen". It represents
/// the title that will be displayed at the top of the menu.
class ActionMenu extends StatelessWidget {
  const ActionMenu({
    required this.children,
    this.title = "Aktionen",
    super.key,
  });

  /// The list of widgets that will be displayed in the menu.
  final List<Widget> children;

  /// The title that will be displayed at the top of the menu.
  final String title;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: Container(
        height: children.length * 56 + 70,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
            ),
          ],
          color: Theme.of(context).colorScheme.background,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            left: 15.0,
            right: 15.0,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 25.5,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: children
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        )
      )
    );
  }
}