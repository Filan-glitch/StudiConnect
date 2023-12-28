import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../controllers/groups.dart';
import '../dialogs/remove_member_dialog.dart';
import '../models/group.dart';
import '../models/redux/app_state.dart';
import '../widgets/avatar_picture.dart';
import '../widgets/location_display.dart';
import '../widgets/page_wrapper.dart';

class GroupInfoPage extends StatelessWidget {
  static const routeName = '/group-info';

  const GroupInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final group = ModalRoute.of(context)!.settings.arguments as Group;

    final members = (group.members ?? []).map((e) => e.id).toList();

    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return PageWrapper(
            title: "Gruppenbeschreibung",
            simpleDesign: true,
            menuActions: [
              if (state.user?.id == group.creator?.id)
                ListTile(
                  leading: const Icon(Icons.group_add),
                  title: const Text('Beitrittsanfragen'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/join-group-requests',
                      arguments: group.id,
                    );
                  },
                ),
              if (state.user?.id == group.creator?.id)
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Gruppe bearbeiten'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/create-and-edit-group',
                      arguments: group,
                    );
                  },
                ),
              if (members.contains(state.user?.id))
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Gruppe verlassen'),
                  onTap: () {
                    leaveGroup(group.id);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home',
                      (route) => false,
                    );
                  },
                ),
              if (!members.contains(state.user?.id))
                ListTile(
                  leading: const Icon(Icons.person_add),
                  title: const Text('Gruppe beitreten'),
                  onTap: () {
                    joinGroup(group.id);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home',
                      (route) => false,
                    );
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25, bottom: 10),
                    child: AvatarPicture(
                      id: group.id,
                      type: Type.group,
                      radius: 65,
                      loadingCircleStrokeWidth: 5.0,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    group.title ?? "",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Modul',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              decorationColor:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        ),
                        Text(
                          group.module ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Beschreibung',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              decorationColor:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        ),
                        Text(
                          group.description ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Treffpunkt',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              decorationColor:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        ),
                        LocationDisplay(
                            lat: group.lat ?? 0, lon: group.lon ?? 0),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Text(
                            "${group.members?.length ?? 0} Mitglieder",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              decorationColor:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: (group.members?.length ?? 0),
                            itemBuilder: (context, index) {
                              final user = group.members?[index];
                              if (user == null) return Container();

                              return ListTile(
                                onLongPress: () {
                                  if (user.id == state.user?.id) return;

                                  showDialog(
                                    context: context,
                                    builder: (context) => RemoveMemberDialog(
                                      user: user,
                                      groupID: group.id,
                                    ),
                                  );
                                },
                                onTap: () {
                                  // NamedRoute pushen
                                  Navigator.pushNamed(context, "/user-info",
                                      arguments: user);
                                },
                                leading: AvatarPicture(
                                  id: user.id,
                                  type: Type.user,
                                  radius: 20,
                                  loadingCircleStrokeWidth: 3.5,
                                ),
                                title: Text(
                                  "${user.username ?? "Unbekannt"} ${user.id == group.creator?.id ? "(Gruppenleiter)" : ""}",
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
