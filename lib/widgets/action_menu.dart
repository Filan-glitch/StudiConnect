import 'dart:ui';
import 'package:flutter/material.dart';

class ActionMenu extends StatelessWidget {
  const ActionMenu({
    required this.children,
    this.title = 'Aktionen',
    super.key,
  });
  final List<Widget> children;
  final String title;

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: Container(
        height: children.length * _height * 0.1,
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
          padding: EdgeInsets.only(
            top: _height * 0.02,
            left: _width * 0.04,
            right: _width * 0.04,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: _width * 0.065,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: children,
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}