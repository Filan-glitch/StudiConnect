/// This library contains the ProfilePage widget.
///
/// {@category PAGES}
library pages.profile_page;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:share_plus/share_plus.dart';
import 'package:studiconnect/constants.dart';
import 'package:studiconnect/main.dart';
import 'package:studiconnect/models/menu_action.dart';
import 'package:studiconnect/widgets/avatar_picture.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';

/// A widget that represents the profile page.
///
/// This widget is a stateless widget that displays the user's profile information.
/// The profile page contains an avatar picture, the user's username, major, university, contact information, and bio.
/// The profile page also has a menu with actions to edit the profile, share the app, and go to the settings page.
class ProfilePage extends StatelessWidget {

  /// Creates a [ProfilePage] widget.
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return PageWrapper(
          title: 'Profil',
          type: PageType.complex,
          menuActions: [
            MenuAction(
              icon: Icons.edit,
              title: 'Profil bearbeiten',
              onTap: () {
                navigatorKey.currentState!.pop();
                navigatorKey.currentState!.pushNamed('/edit-profile');
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
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 15),
                    child: AvatarPicture(
                      id: state.user?.id,
                      type: Type.user,
                      radius: 65,
                      loadingCircleStrokeWidth: 5.0,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    state.user?.username ?? '-',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Studiengang',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          decorationColor:
                              Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ),
                    Text(
                      state.user?.major ?? '-',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Universität',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          decorationColor:
                              Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ),
                    Text(
                      state.user?.university ?? '-',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Kontaktmöglichkeiten',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          decorationColor:
                              Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ),
                    Text(
                      'E-Mail: ${state.user?.email ?? '-'}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Tel: ${state.user?.mobile ?? '-'}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Discord: ${state.user?.discord ?? '-'}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Über mich',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          decorationColor:
                              Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ),
                    Text(
                      state.user?.bio ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 85),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}