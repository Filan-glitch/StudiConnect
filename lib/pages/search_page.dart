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
