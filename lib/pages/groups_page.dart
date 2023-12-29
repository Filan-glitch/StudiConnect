import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/models/group.dart';
import 'package:studiconnect/models/user.dart';
import 'package:studiconnect/widgets/group_list_item.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: add reload -> reload all user data
    return PageWrapper(
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
      menuActions: [
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text('Gruppe erstellen'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/create-and-edit-group');
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
