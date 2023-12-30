/// This library contains the GroupsPage widget.
///
/// {@category PAGES}
library pages.groups_page;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/widgets/group_list_item.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';

/// A StatefulWidget that displays a list of the user's groups.
///
/// The page contains a list of the user's groups, each represented by a [GroupListItem].
/// If the user is not a member of any groups, they are presented with the option to create a group.
class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

/// The state for the [GroupsPage] widget.
///
/// This class contains the logic for handling the user's interactions with the page.
class _GroupsPageState extends State<GroupsPage> {

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      /// The body of the page is a list of the user's groups.
      /// If the user is not a member of any groups, they are presented with the option to create a group.
      body: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, state) {
              if ((state.user?.groups ?? []).isEmpty) {
                return LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Du bist noch keiner Gruppe beigetreten"),
                          const SizedBox(height: 50),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/create-and-edit-group');
                            },
                            child: const Text("Gruppe erstellen"),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: (state.user?.groups ?? [])
                      .map((group) => GroupListItem(group: group))
                      .toList(),
                ),
              );
            }),
      ),
      /// The menu actions include the options to create a group and to navigate to the settings page.
      menuActions: [
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text('Gruppe erstellen'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/create-and-edit-group');
            setState(() {});
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
      title: 'Gruppen',
    );
  }
}