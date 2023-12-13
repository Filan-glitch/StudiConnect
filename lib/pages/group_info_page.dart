import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
            title: group.title,
            simpleDesign: true,
            menuActions: [
              if (state.user?.uid == group.creator.uid) ListTile(
                leading: const Icon(Icons.group_add),
                title: const Text('Beitrittsanfragen'),
                onTap: () {

                },
              ),
              if (state.user?.uid == group.creator.uid) ListTile(
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
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Gruppe verlassen'),
                onTap: () {

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
            // TODO: Add group info
            // Gruppenbild oben mittig
            // Gruppenbeschreibung darunter mittig
            // Darunter ein kleinen Titel "{count} Mitglieder"
            // Darunter eine Liste mit allen Mitgliedern, die Mitglieder sind klickbar
            // Wenn man auf ein Mitglied klickt öffnet sich die UserInfoPage
            body: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Gruppenbild
                    CircleAvatar(
                      backgroundImage: NetworkImage(group.photoUrl),
                    ),
                    //Gruppenbeschreibung
                    Text(group.description),
                    //Mitgliederanzahl
                    Text("${group.members.length} Mitglieder"),
                    //Mitgliederliste
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: group.members.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/user-info',
                              arguments: group.members[index],
                            );
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(group.members[index].photoUrl),
                          ),
                          title: Text(group.members[index].username),
                          subtitle: Text(group.members[index].email),
                        );
                      },
                    ),
                  ],
                )
              )
            )
        );
      },
    );
  }
}