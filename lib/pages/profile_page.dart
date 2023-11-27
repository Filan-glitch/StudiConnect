import 'package:flutter/material.dart';
import '/widgets/page_wrapper.dart';

import '/pages/search_page.dart';
import 'home_page.dart';

class ProfilePage extends StatelessWidget {
const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: Scaffold(
      body: const Center(
        child: Text('This is the profile page'),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
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
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                        (route) => false
                );
                break;
              case 1:
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                        (route) => false
                );
                break;
              case 2:
                break;
            }
          }
      ),
    ),

    );
  }
}