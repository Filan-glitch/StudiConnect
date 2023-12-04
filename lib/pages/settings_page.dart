import 'package:flutter/material.dart';

import '../widgets/page_wrapper.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageWrapper(
      title: "Einstellungen",
      body: Center(
        child: Text("Einstellungen"),
      ),
      simpleDesign: true,
    );
  }
}