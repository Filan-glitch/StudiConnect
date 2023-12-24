import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../constants.dart';
import '../models/group.dart';
import '../models/redux/app_state.dart';
import '../widgets/page_wrapper.dart';

class GroupInfoPage extends StatelessWidget {
  static const routeName = '/group-info';

  const GroupInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final group = ModalRoute.of(context)!.settings.arguments as Group;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return PageWrapper(
            title: group.title ?? "Gruppe",
            simpleDesign: true,
            menuActions: [
              if (state.user?.id == group.creator?.id) ListTile(
                leading: const Icon(Icons.group_add),
                title: const Text('Beitrittsanfragen'),
                onTap: () {
                  Navigator.pushNamed(context, '/join-group-requests', arguments: group.joinRequests ?? []);
                },
              ),
              if (state.user?.id == group.creator?.id) ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Gruppe bearbeiten'),
                onTap: () {
                  Navigator.pushNamed(
                      context,
                      '/create-and-edit-group',
                      arguments: group
                  );
                },
              ),
              if (group.members?.contains(state.user) ?? false) ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Gruppe verlassen'),
                onTap: () {
                  //TODO: API Call and update data
                },
              ),
              if (!(group.members?.contains(state.user) ?? true)) ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Gruppe beitreten'),
                onTap: () {
                  //TODO: API Call and update data
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Einstellungen'),
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ],
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Gruppenbild
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25, bottom: 10),
                    child: CircleAvatar(
                      radius: 65,
                      backgroundImage: NetworkImage(
                        '$backendURL/api/group/${group.id}/image',
                      ),
                    ),
                  )
                ),
                //Modul
                Center(
                  child: Text(
                    group.module ?? "",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //Gruppenbeschreibung
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      group.description ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                ),
                //Gruppenmitgliederanzahl
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10),
                  child: Text(
                    "${(group.members?.length ?? 0) + 1} Mitglieder",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //Gruppenmitglieder Liste
                Expanded(child: ListView.builder(
                  itemCount: (group.members?.length ?? 0) + 1,
                  itemBuilder: (context, index) {
                    final user = index == 0 ? group.creator : group.members?[index - 1];
                    return ListTile(
                      onTap: () {
                        // NamedRoute pushen
                        Navigator.pushNamed(context, "/user-info", arguments: user);
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          '$backendURL/api/user/${user?.id}/image',
                        ),
                      ),
                      title: Text(user?.username ?? "Unbekannt"),
                    );
                  },
                ))
              ],
            ),
        );
      }
    );
  }
}