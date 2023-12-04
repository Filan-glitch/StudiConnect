import 'package:flutter/material.dart';

import '../widgets/page_wrapper.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: const Scaffold(
        body: Center(
          child: Text('This is the chats page'),
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
          leading: const Icon(Icons.create_outlined),
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
      title: 'Hallo,\nMax Mustermann!',
    );
  }
}
