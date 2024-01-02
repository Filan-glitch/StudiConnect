import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:share_plus/share_plus.dart';
import 'package:studiconnect/widgets/avatar_picture.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return PageWrapper(
          body: SingleChildScrollView(
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
                      "E-Mail: ${state.user?.email ?? '-'}",
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "Tel: ${state.user?.mobile ?? '-'}",
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "Discord: ${state.user?.discord ?? '-'}",
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
                  ],
                ),
              ],
            ),
          ),
          menuActions: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Profil bearbeiten'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/edit-profile');
              },
            ),
            ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Studiconnect weiterempfehlen'),
                onTap: () {
                  Share.share(
                      'Schau dir StudiConnect an: https://play.google.com/store/apps/details?id=de.studiconnect.app');
                }),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Einstellungen'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
          title: 'Profil',
        );
      },
    );
  }
}
