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
      creator: User(id: "1", username: "Jan Bellenberg"),
      members: [
        User(id: "2", username: "User 1"),
        User(id: "3", username: "User 2"),
        User(id: "4", username: "User 3"),
      ],
    ),
    Group(
      id: '2',
      title: 'Gruppe 2',
      createdAt: "2023-12-11",
      creator: User(id: "1", username: "Jan Bellenberg"),
      members: [
        User(id: "5", username: "User 1"),
        User(id: "6", username: "User 2"),
        User(id: "7", username: "User 3"),
      ],
    ),
    Group(
      id: '2',
      title: 'Gruppe 3',
      createdAt: "2023-12-11",
      creator: User(id: "1", username: "Jan Bellenberg"),
      members: [
        User(id: "8", username: "User 1"),
        User(id: "9", username: "User 2"),
        User(id: "10", username: "User 3"),
      ],
    ),
    Group(
      id: '3',
      title: 'Gruppe 4',
      createdAt: "2023-12-11",
      creator: User(id: "1", username: "Jan Bellenberg"),
      members: [
        User(id: "11", username: "User 1"),
        User(id: "12", username: "User 2"),
        User(id: "13", username: "User 3"),
      ],
    ),
    Group(
      id: '4',
      title: 'Gruppe 5',
      createdAt: "2023-12-11",
      creator: User(id: "1", username: "Jan Bellenberg"),
      members: [
        User(id: "14", username: "User 1"),
        User(id: "15", username: "User 2"),
        User(id: "16", username: "User 3"),
      ],
    ),
    Group(
      id: '5',
      title: 'Gruppe 6',
      createdAt: "2023-12-11",
      creator: User(id: "1", username: "Jan Bellenberg"),
      members: [
        User(id: "17", username: "User 1"),
        User(id: "18", username: "User 2"),
        User(id: "19", username: "User 3"),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: 'Suche',
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
      menuActions: [
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Einstellungen'),
          onTap: () {
            Navigator.pushNamed(context, '/settings');
          },
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
          padding: const EdgeInsets.only(bottom: 100),
          itemBuilder: (context, index) {
            Group group = searchResultsMock[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: GestureDetector(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.title!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Erstellt an ${group.createdAt}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Erstellt von ${group.creator!.username}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Mitglieder: ${group.members!.length}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/group-info',
                        arguments: group);
                  }),
            );
          },
        ),
      ),
    );
  }
}
