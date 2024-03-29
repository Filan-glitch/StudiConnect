/// This library contains the GroupInfoPage widget.
///
/// {@category PAGES}
library pages.group_info_page;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:latlong2/latlong.dart';
import 'package:studiconnect/dialogs/remove_member_dialog.dart';
import 'package:studiconnect/controllers/groups.dart';
import 'package:studiconnect/main.dart';
import 'package:studiconnect/models/group_parameter.dart';
import 'package:studiconnect/models/menu_action.dart';
import 'package:studiconnect/models/user_parameter.dart';
import 'package:studiconnect/widgets/avatar_picture.dart';
import 'package:studiconnect/widgets/location_display.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';

/// A StatefulWidget that displays information about a group.
///
/// The page contains the group's avatar, title, module, description, and location,
/// as well as a list of the group's members.
/// If the user is a member of the group, they have the option to leave the group.
/// If the user is not a member of the group, they have the option to join the group.
/// If the user is the creator of the group, they have the option to edit the group or manage join requests.
class GroupInfoPage extends StatefulWidget {

  /// Creates a [GroupInfoPage] widget.
  const GroupInfoPage({super.key});

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

/// The state for the [GroupInfoPage] widget.
///
/// This class contains the logic for handling the user's interactions with the page.
class _GroupInfoPageState extends State<GroupInfoPage> {
  GroupLookupParameters? groupParams;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        groupParams = ModalRoute.of(context)!.settings.arguments
            as GroupLookupParameters?;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          final group = groupParams?.getGroup(context);
          if (group == null) return Container();

          final members = (group.members ?? []).map((e) => e.id).toList();
          return PageWrapper(
            title: 'Gruppenbeschreibung',
            menuActions: [
              if (state.user?.id == group.creator?.id)
                MenuAction(
                  icon: Icons.group_add,
                  title: 'Beitrittsanfragen',
                  onTap: () {
                    navigatorKey.currentState!.pushNamed(
                      '/join-group-requests',
                      arguments: group.id,
                    );
                  },
                ),
              if (state.user?.id == group.creator?.id)
                MenuAction(
                  icon: Icons.edit,
                  title: 'Gruppe bearbeiten',
                  onTap: () async {
                    await navigatorKey.currentState!.pushNamed(
                      '/create-and-edit-group',
                      arguments: groupParams,
                    );
                  },
                ),
              if (members.contains(state.user?.id) &&
                  group.creator?.id != state.user?.id)
                MenuAction(
                  icon: Icons.exit_to_app,
                  title: 'Gruppe verlassen',
                  onTap: () async {
                    final bool successful = await leaveGroup(group.id);

                    if (!successful) {
                      return;
                    }

                    navigatorKey.currentState!.pushNamedAndRemoveUntil(
                      '/home',
                      (route) => false,
                    );
                  },
                ),
              if (!members.contains(state.user?.id))
                MenuAction(
                  icon: Icons.person_add,
                  title: 'Gruppe beitreten',
                  onTap: () async {
                    final bool successful = await joinGroup(group.id);

                    if (!successful) {
                      return;
                    }

                    navigatorKey.currentState!.pop();
                    navigatorKey.currentState!.pushNamedAndRemoveUntil(
                      '/home',
                      (route) => false,
                    );
                  },
                ),
              MenuAction(
                icon: Icons.settings,
                title: 'Einstellungen',
                onTap: () {
                  navigatorKey.currentState!.pop();
                  navigatorKey.currentState!.pushNamed('/settings');
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
                    group.title ?? '',
                    style: const TextStyle(
                      fontSize: 16,
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
                          group.module ?? '',
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
                          group.description ?? '',
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 60,
                          child: LocationDisplay(
                            position: LatLng(
                              group.lat ?? 0,
                              group.lon ?? 0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Text(
                            '${group.members?.length ?? 0} Mitglieder',
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
                                  if (user.id == state.user?.id || user.id != group.creator) return;

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
                                  Navigator.pushNamed(
                                    context,
                                    '/user-info',
                                    arguments: UserLookupParameters(
                                      userID: user.id,
                                      source: UserSource.groupMember,
                                      groupLookupParameters: groupParams,
                                    ),
                                  );
                                },
                                leading: AvatarPicture(
                                  id: user.id,
                                  type: Type.user,
                                  radius: 20,
                                  loadingCircleStrokeWidth: 3.5,
                                ),
                                title: Text(
                                  '${user.username ?? 'Unbekannt'} ${user.id == group.creator?.id ? '(Gruppenleiter)' : ''}',
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
