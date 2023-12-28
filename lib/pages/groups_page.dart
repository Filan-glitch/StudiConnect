import 'package:flutter/material.dart';

import 'package:studiconnect/models/group.dart';
import 'package:studiconnect/models/user.dart';
import 'package:studiconnect/widgets/group_list_item.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';

class GroupsPage extends StatelessWidget {
  final List<Widget> childrenMock = [
    GroupListItem(
        group: Group(
      id: '1',
      title: 'Gruppe 1',
      description: 'Beschreibung 1',
      module: 'Modul 1',

      members: <User>[
        User(
            id: '2',
            username: 'Maxine Musterfrau',
            email: 'maxine.musterfrau@mail.de',
            university: 'Hochschule Ruhr West',
            major: 'Informatik',
            bio: 'Hallo, ich bin Maxine Musterfrau.',
            discord: 'maxine.musterfrau'),
        User(
            id: '2',
            username: 'Maxine Musterfrau',
            email: 'maxine.musterfrau@mail.de',
            university: 'Hochschule Ruhr West',
            major: 'Informatik',
            bio: 'Hallo, ich bin Maxine Musterfrau.',
            discord: 'maxine.musterfrau'),
        User(
            id: '2',
            username: 'Maxine Musterfrau',
            email: 'maxine.musterfrau@mail.de',
            university: 'Hochschule Ruhr West',
            major: 'Informatik',
            bio: 'Hallo, ich bin Maxine Musterfrau.',
            discord: 'maxine.musterfrau'),
        User(
            id: '2',
            username: 'Maxine Musterfrau',
            email: 'maxine.musterfrau@mail.de',
            university: 'Hochschule Ruhr West',
            major: 'Informatik',
            bio: 'Hallo, ich bin Maxine Musterfrau.',
            discord: 'maxine.musterfrau'),
        User(
            id: '2',
            username: 'Maxine Musterfrau',
            email: 'maxine.musterfrau@mail.de',
            university: 'Hochschule Ruhr West',
            major: 'Informatik',
            bio: 'Hallo, ich bin Maxine Musterfrau.',
            discord: 'maxine.musterfrau'),
        User(
            id: '2',
            username: 'Maxine Musterfrau',
            email: 'maxine.musterfrau@mail.de',
            university: 'Hochschule Ruhr West',
            major: 'Informatik',
            bio: 'Hallo, ich bin Maxine Musterfrau.',
            discord: 'maxine.musterfrau'),
        User(
            id: '2',
            username: 'Maxine Musterfrau',
            email: 'maxine.musterfrau@mail.de',
            university: 'Hochschule Ruhr West',
            major: 'Informatik',
            bio: 'Hallo, ich bin Maxine Musterfrau.',
            discord: 'maxine.musterfrau'),
        User(
            id: '2',
            username: 'Maxine Musterfrau',
            email: 'maxine.musterfrau@mail.de',
            university: 'Hochschule Ruhr West',
            major: 'Informatik',
            bio: 'Hallo, ich bin Maxine Musterfrau.',
            discord: 'maxine.musterfrau'),
        User(
            id: '2',
            username: 'Maxine Musterfrau',
            email: 'maxine.musterfrau@mail.de',
            university: 'Hochschule Ruhr West',
            major: 'Informatik',
            bio: 'Hallo, ich bin Maxine Musterfrau.',
            discord: 'maxine.musterfrau'),
        User(
            id: '2',
            username: 'Maxine Musterfrau',
            email: 'maxine.musterfrau@mail.de',
            university: 'Hochschule Ruhr West',
            major: 'Informatik',
            bio: 'Hallo, ich bin Maxine Musterfrau.',
            discord: 'maxine.musterfrau'),
      ],
      joinRequests: <User>[
        User(
            id: '2',
            username: 'Maxine Musterfrau',
            email: 'maxine.musterfrau@mail.de',
            university: 'Hochschule Ruhr West',
            major: 'Informatik',
            bio: 'Hallo, ich bin Maxine Musterfrau.',
            discord: 'maxine.musterfrau'),
        User(
            id: '2',
            username: 'Maxine Musterfrau',
            email: 'maxine.musterfrau@mail.de',
            university: 'Hochschule Ruhr West',
            major: 'Informatik',
            bio: 'Hallo, ich bin Maxine Musterfrau.',
            discord: 'maxine.musterfrau'),
        User(
            id: '2',
            username: 'Maxine Musterfrau',
            email: 'maxine.musterfrau@mail.de',
            university: 'Hochschule Ruhr West',
            major: 'Informatik',
            bio: 'Hallo, ich bin Maxine Musterfrau.',
            discord: 'maxine.musterfrau'),
      ],
      createdAt: DateTime.now(),
      lat: 51.527467,
      lon: 6.927127,
    )),
    GroupListItem(
        group: Group(
      id: '2',
      title: 'Gruppe 2',
      description: 'Beschreibung 2',
      module: 'Modul 2',
      creator: User(
          id: '1',
          username: 'Max Mustermann',
          email: 'max.mustermann@mail.de',
          university: 'Hochschule Ruhr West',
          major: 'Informatik',
          bio: 'Hallo, ich bin Max Mustermann.',
          discord: 'max.mustermann'),
      members: <User>[],
      createdAt: DateTime.now(),
      lat: 51.527467,
      lon: 6.927127,
    )),
  ];

  GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: childrenMock,
          ),
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
