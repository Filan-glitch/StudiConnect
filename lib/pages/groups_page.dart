import 'package:flutter/material.dart';

import '../models/group.dart';
import '../widgets/group_list_item.dart';
import '../widgets/page_wrapper.dart';

class GroupsPage extends StatelessWidget {
  final List<Widget> children = [
    GroupListItem(
      group: const Group(
        id: '1',
        name: 'Gruppe 1',
        description: 'Beschreibung 1',
        photoUrl: 'https://picsum.photos/200',
      ),
      onTap: () {  },
    ),
  ];

  GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: children,
          )
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Gruppen',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Suche',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_sharp),
                label: 'Profil'
            ),
          ],
          currentIndex: 0,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: (index) {
            switch (index) {
              case 0:
                break;
              case 1:
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/search',
                    (route) => false
                );
                break;
              case 2:
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/profile',
                    (route) => false
                );
                break;
            }
          }
      ),
      menuActions: [
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text('Gruppe erstellen'),
          onTap: () {
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
