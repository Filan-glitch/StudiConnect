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
