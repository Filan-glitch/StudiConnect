import 'package:flutter/material.dart';

import 'settings_page.dart';
import 'home_page.dart';

class ProfilePage extends StatelessWidget {
const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('This is the profile page'),
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
          currentIndex: 1,
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
                break;
              case 2:
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                        (route) => false
                );
                break;
            }
          }
      ),
    );
  }
}