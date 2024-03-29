/// This library contains the GroupsPage widget.
///
/// {@category PAGES}
library pages.groups_page;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:share_plus/share_plus.dart';
import 'package:studiconnect/constants.dart';
import 'package:studiconnect/controllers/user.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/widgets/group_list_item.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';
import 'package:studiconnect/main.dart';
import 'package:studiconnect/models/menu_action.dart';

/// A StatefulWidget that displays a list of the user's groups.
///
/// The page contains a list of the user's groups, each represented by a [GroupListItem].
/// If the user is not a member of any groups, they are presented with the option to create a group.
class GroupsPage extends StatefulWidget {

  /// Creates a [GroupsPage] widget.
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
      title: 'Gruppen',
      type: PageType.complex,
      /// The menu actions include the options to create a group and to navigate to the settings page.
      menuActions: [
        MenuAction(
          icon: Icons.add,
          title: 'Gruppe erstellen',
          onTap: () {
            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pushNamed('/create-and-edit-group');
            setState(() {});
          },
        ),
        MenuAction(
          icon: Icons.share,
          title: 'Studiconnect weiterempfehlen',
          onTap: () {
            navigatorKey.currentState!.pop();
            Share.share(
              'Schau dir StudiConnect an: https://play.google.com/store/apps/details?id=$appID');
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
      /// The body of the page is a list of the user's groups.
      /// If the user is not a member of any groups, they are presented with the option to create a group.
      body: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: RefreshIndicator(
          onRefresh: () async {
            await loadUserInfo();
          },
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
                            const Center(
                              child: Text('Du bist noch keiner Gruppe beigetreten'),
                            ),
                            const SizedBox(height: 50),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/create-and-edit-group',
                                  );
                                },
                                child: const Text('Gruppe erstellen'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: state.user?.groups?.length ?? 0,
                  itemBuilder: (context, index) {
                    final group = state.user!.groups![index];
                    return GroupListItem(
                      group: group,
                    );
                  },
                );
              }
          ),
          backgroundColor: Theme.of(context).progressIndicatorTheme.refreshBackgroundColor,
          semanticsLabel: 'Gruppen werden geladen',
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
        ),
      ),
    );
  }
}