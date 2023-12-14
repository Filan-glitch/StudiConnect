import 'package:flutter/material.dart';

//import '../models/group.dart';

class GroupInfoPage extends StatelessWidget {
  static const routeName = '/group-info';

  const GroupInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context)!.settings.arguments as Group;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Info'),
      ),
      body: const Center(
        child: Text('Group Info Page'),
      ),
    );
  }
}