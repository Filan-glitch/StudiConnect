import 'package:flutter/material.dart';

import '/widgets/page_wrapper.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: const Scaffold(
        body: Center(
          child: Text('This is the search page'),
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
          currentIndex: 1,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/groups',
                    (route) => false
                );
                break;
              case 1:
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
          leading: const Icon(Icons.settings),
          title: const Text('Einstellungen'),
          onTap: () {
            Navigator.pushNamed(context, '/settings');
          },
        ),
      ],
      title: 'Suche',

    );
  }
}