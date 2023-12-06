import 'package:flutter/material.dart';
import '/widgets/page_wrapper.dart';

import '/pages/search_page.dart';
import 'groups_page.dart';

class ProfilePage extends StatelessWidget {
const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: const Scaffold(
        body: Center(
        child: Text('This is the profile page'),
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
              label: 'Profil',
            ),
          ],
          currentIndex: 2,
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
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/search',
                    (route) => false
                );
                break;
              case 2:
                break;
            }
          }
      ),
      menuActions: [
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Profil bearbeiten'),
          onTap: () {
            Navigator.pushNamed(context, '/edit-profile');
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
      title: 'Profil',

    );
  }
}