import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:share_plus/share_plus.dart';
import 'package:studiconnect/constants.dart';
import 'package:studiconnect/controllers/user.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/widgets/group_list_item.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';
import 'package:studiconnect/main.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: 'Gruppen',
      type: PageType.complex,
      menuActions: [
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text('Gruppe erstellen'),
          onTap: () {
            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pushNamed('/create-and-edit-group');
            setState(() {});
          },
        ),
        ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Studiconnect weiterempfehlen'),
            onTap: () {
              navigatorKey.currentState!.pop();
              Share.share(
                  'Schau dir StudiConnect an: https://play.google.com/store/apps/details?id=$appID');
            }),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Einstellungen'),
          onTap: () {
            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pushNamed('/settings');
          },
        ),
      ],
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
                            const Text("Du bist noch keiner Gruppe beigetreten"),
                            const SizedBox(height: 50),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/create-and-edit-group',
                                );
                              },
                              child: const Text("Gruppe erstellen"),
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
