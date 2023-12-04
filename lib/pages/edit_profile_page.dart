import 'package:flutter/material.dart';

import '/widgets/page_wrapper.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  @override
  Widget build(BuildContext context) {
    return const PageWrapper(
      title: "Profil bearbeiten",
      body: Center(
        child: Text("Profil bearbeiten"),
      ),
      simpleDesign: true,
    );
  }
}