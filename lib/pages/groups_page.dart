import 'package:flutter/material.dart';

import '../models/group.dart';
import '../widgets/group_list_item.dart';
import '../widgets/page_wrapper.dart';

class GroupsPage extends StatelessWidget {
  final List<Widget> children = [
    GroupListItem(
      group: const Group(
        id: '1',
        title: 'Gruppe 1',
        description: 'Beschreibung 1',
      ),
      onTap: () {},
    ),
  ];

  GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: children,
        ),
      ),
      menuActions: [
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text('Gruppe erstellen'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/create-group');
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Einstellungen'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/settings');
          },
        ),
      ],
      title: 'Gruppen',
    );
  }
}
