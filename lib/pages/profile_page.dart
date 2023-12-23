import 'dart:ui';

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
                      child: Image.network(
                        "$backendURL/api/users/${state.user?.id}/image",
                        fit: BoxFit.cover,
                        errorBuilder: (
                          BuildContext context,
                          Object exception,
                          StackTrace? stackTrace,
                        ) {
                          return Container(
                            color: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 80.0,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    state.user?.username ?? 'ERROR',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'Studiengang',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          state.user?.major ?? 'ERROR',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(height: 10),
                        const Text(
                          'Universität',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          state.user?.university ?? 'ERROR',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Kontaktmöglichkeiten',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          state.user?.email ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          state.user?.mobile ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          state.user?.discord ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Über mich',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          state.user?.bio ?? 'ERROR',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    )),
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
