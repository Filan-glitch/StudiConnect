import 'package:flutter/material.dart';

class MenuAction {
  final String title;
  final IconData icon;
  final Function onTap;

  MenuAction({required this.title, required this.icon, required this.onTap});
}
