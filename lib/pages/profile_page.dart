import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../constants.dart';
import '../models/redux/app_state.dart';
import '/widgets/page_wrapper.dart';

// TODO: show profile of other user
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
                    child: Container(
                        width: 100,
                        height: 100,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Stack(
                            children: [
                              Image.network(
                                  "$backendURL/api/users/${state.user?.id}/image",
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    // ERROR Logging
                                    return Container();
                                  }
                              ),
                              Container(
                                color: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  size: 100.0,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              )
                            ]
                        )
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
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Studiengang',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          // underlined
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(context).textTheme.bodySmall?.color,
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
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Universität',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(context).textTheme.bodySmall?.color,
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
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Kontaktmöglichkeiten',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(context).textTheme.bodySmall?.color,
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
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Über mich',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(context).textTheme.bodySmall?.color,
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
