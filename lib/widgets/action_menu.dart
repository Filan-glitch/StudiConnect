import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:studiconnect/models/menu_action.dart';

class ActionMenu extends StatelessWidget {
  const ActionMenu({
    required this.children,
    this.title = 'Aktionen',
    super.key,
  });
  final List<MenuAction> children;
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
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 25.5,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: children.map((MenuAction action) {
                    return ListTile(
                      leading: Icon(
                        action.icon,
                      ),
                      title: Text(
                        action.title,
                      ),
                      onTap: () {
                        action.onTap();
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}