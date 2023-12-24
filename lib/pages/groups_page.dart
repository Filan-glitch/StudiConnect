import 'package:flutter/material.dart';

import '../models/group.dart';
import '../models/user.dart';
import '../widgets/group_list_item.dart';
import '../widgets/page_wrapper.dart';

class GroupsPage extends StatelessWidget {
  final List<Widget> children = [
    GroupListItem(
      group: Group(
        id: '1',
        title: 'Gruppe 1',
        description: 'Beschreibung 1',
        module: 'Modul 1',
        members: <User>[
          User(id: '2', username: 'Maxine Musterfrau', email: 'maxine.musterfrau@mail.de', university: 'Hochschule Ruhr West', major: 'Informatik', bio: 'Hallo, ich bin Maxine Musterfrau.', discord: 'maxine.musterfrau'),
          User(id: '2', username: 'Maxine Musterfrau', email: 'maxine.musterfrau@mail.de', university: 'Hochschule Ruhr West', major: 'Informatik', bio: 'Hallo, ich bin Maxine Musterfrau.', discord: 'maxine.musterfrau'),
          User(id: '2', username: 'Maxine Musterfrau', email: 'maxine.musterfrau@mail.de', university: 'Hochschule Ruhr West', major: 'Informatik', bio: 'Hallo, ich bin Maxine Musterfrau.', discord: 'maxine.musterfrau'),
          User(id: '2', username: 'Maxine Musterfrau', email: 'maxine.musterfrau@mail.de', university: 'Hochschule Ruhr West', major: 'Informatik', bio: 'Hallo, ich bin Maxine Musterfrau.', discord: 'maxine.musterfrau'),
          User(id: '2', username: 'Maxine Musterfrau', email: 'maxine.musterfrau@mail.de', university: 'Hochschule Ruhr West', major: 'Informatik', bio: 'Hallo, ich bin Maxine Musterfrau.', discord: 'maxine.musterfrau'),
          User(id: '2', username: 'Maxine Musterfrau', email: 'maxine.musterfrau@mail.de', university: 'Hochschule Ruhr West', major: 'Informatik', bio: 'Hallo, ich bin Maxine Musterfrau.', discord: 'maxine.musterfrau'),
          User(id: '2', username: 'Maxine Musterfrau', email: 'maxine.musterfrau@mail.de', university: 'Hochschule Ruhr West', major: 'Informatik', bio: 'Hallo, ich bin Maxine Musterfrau.', discord: 'maxine.musterfrau'),
          User(id: '2', username: 'Maxine Musterfrau', email: 'maxine.musterfrau@mail.de', university: 'Hochschule Ruhr West', major: 'Informatik', bio: 'Hallo, ich bin Maxine Musterfrau.', discord: 'maxine.musterfrau'),
          User(id: '2', username: 'Maxine Musterfrau', email: 'maxine.musterfrau@mail.de', university: 'Hochschule Ruhr West', major: 'Informatik', bio: 'Hallo, ich bin Maxine Musterfrau.', discord: 'maxine.musterfrau'),
          User(id: '2', username: 'Maxine Musterfrau', email: 'maxine.musterfrau@mail.de', university: 'Hochschule Ruhr West', major: 'Informatik', bio: 'Hallo, ich bin Maxine Musterfrau.', discord: 'maxine.musterfrau'),
        ],
        joinRequests: <User>[
          User(id: '2', username: 'Maxine Musterfrau', email: 'maxine.musterfrau@mail.de', university: 'Hochschule Ruhr West', major: 'Informatik', bio: 'Hallo, ich bin Maxine Musterfrau.', discord: 'maxine.musterfrau'),
          User(id: '2', username: 'Maxine Musterfrau', email: 'maxine.musterfrau@mail.de', university: 'Hochschule Ruhr West', major: 'Informatik', bio: 'Hallo, ich bin Maxine Musterfrau.', discord: 'maxine.musterfrau'),
          User(id: '2', username: 'Maxine Musterfrau', email: 'maxine.musterfrau@mail.de', university: 'Hochschule Ruhr West', major: 'Informatik', bio: 'Hallo, ich bin Maxine Musterfrau.', discord: 'maxine.musterfrau'),
        ],
        createdAt: "01.01.1970",
        lat: 0.0000,
        lon: 0.0000,
      )
    ),
    GroupListItem(
        group: Group(
          id: '2',
          title: 'Gruppe 2',
          description: 'Beschreibung 2',
          module: 'Modul 2',
          creator: User(id: '1', username: 'Max Mustermann', email: 'max.mustermann@mail.de', university: 'Hochschule Ruhr West', major: 'Informatik', bio: 'Hallo, ich bin Max Mustermann.', discord: 'max.mustermann'),
          members: <User>[],
          createdAt: "01.01.1970",
          lat: 0.0000,
          lon: 0.0000,
        )
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
            Navigator.pushNamed(context, '/create-and-edit-group');
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
