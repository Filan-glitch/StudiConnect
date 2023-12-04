import 'package:flutter/material.dart';

import '/widgets/page_wrapper.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  @override
  Widget build(BuildContext context) {
    return const PageWrapper(
      title: "Create Group",
      body: Center(
        child: Text("Create Group"),
      ),
      simpleDesign: true,
    );
  }
}