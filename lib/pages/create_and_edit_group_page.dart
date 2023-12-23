import 'package:flutter/material.dart';

import '../models/group.dart';
import '/widgets/page_wrapper.dart';

class CreateAndEditGroupPage extends StatefulWidget {
  static const routeName = '/create-and-edit-group';

  const CreateAndEditGroupPage({super.key});

  @override
  State<CreateAndEditGroupPage> createState() => _CreateAndEditGroupPageState();
}

class _CreateAndEditGroupPageState extends State<CreateAndEditGroupPage> {
  @override
  Widget build(BuildContext context) {
    final group = ModalRoute.of(context)!.settings.arguments as Group?;

    return const PageWrapper(
      title: "Create or edit Group",
      body: Center(
        child: Text("Create or edit Group"),
      ),
      simpleDesign: true,
    );
  }
}