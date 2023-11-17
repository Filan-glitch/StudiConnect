import 'package:flutter/material.dart';
import 'package:studiconnect/pages/profile_page.dart';

import 'home_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('This is the settings page'),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_sharp),
              label: 'Profil',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Einstellungen'
            ),
          ],
          currentIndex: 2,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                        (route) => false
                );
                break;
              case 1:
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                        (route) => false
                );
                break;
              case 2:
                break;
            }
          }
      ),
    );
  }
}