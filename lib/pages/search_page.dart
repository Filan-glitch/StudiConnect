import 'package:flutter/material.dart';

import '../models/group.dart';
import '../models/user.dart';
import '/widgets/page_wrapper.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _moduleInputController = TextEditingController();
  double _radius = 10;

  final List<Group> searchResultsMock = [
    Group(
      id: '1',
      title: 'Gruppe 1',
      createdAt: "2023-12-11",
      creator: User(username: "Jan Bellenberg"),
      members: [
        User(username: "User 1"),
        User(username: "User 2"),
        User(username: "User 3"),
      ],
    ),
    Group(
      id: '2',
      title: 'Gruppe 2',
      createdAt: "2023-12-11",
      creator: User(username: "Jan Bellenberg"),
      members: [
        User(username: "User 1"),
        User(username: "User 2"),
        User(username: "User 3"),
      ],
    ),
    Group(
      id: '1',
      title: 'Gruppe 1',
      createdAt: "2023-12-11",
      creator: User(username: "Jan Bellenberg"),
      members: [
        User(username: "User 1"),
        User(username: "User 2"),
        User(username: "User 3"),
      ],
    ),
    Group(
      id: '2',
      title: 'Gruppe 2',
      createdAt: "2023-12-11",
      creator: User(username: "Jan Bellenberg"),
      members: [
        User(username: "User 1"),
        User(username: "User 2"),
        User(username: "User 3"),
      ],
    ),
    Group(
      id: '1',
      title: 'Gruppe 1',
      createdAt: "2023-12-11",
      creator: User(username: "Jan Bellenberg"),
      members: [
        User(username: "User 1"),
        User(username: "User 2"),
        User(username: "User 3"),
      ],
    ),
    Group(
      id: '2',
      title: 'Gruppe 2',
      createdAt: "2023-12-11",
      creator: User(username: "Jan Bellenberg"),
      members: [
        User(username: "User 1"),
        User(username: "User 2"),
        User(username: "User 3"),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      headerControls: [
        TextField(
          controller: _moduleInputController,
          // change label and border color
          decoration: const InputDecoration(
            labelText: "Modul",
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            children: [
              const Text("Radius:", style: TextStyle(color: Colors.white)),
              Expanded(
                child: Slider(
                  inactiveColor: Colors.white,
                  activeColor: Colors.white,
                  min: 0,
                  max: 100,
                  value: _radius,
                  onChanged: (value) {
                    setState(() {
                      _radius = value;
                    });
                  },
                ),
              ),
              Text("${_radius.toInt()} km",
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 20.0,
        ),
        child: ListView.builder(
          itemCount: searchResultsMock.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            Group group = searchResultsMock[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.title!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Erstellt an ${group.createdAt}'),
                  Text('Erstellt von ${group.creator!.username}'),
                  Text('Mitglieder: ${group.members!.length}'),
                ],
              ),
            );
          },
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
