import 'package:flutter/material.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';

import '../constants.dart';
import '../models/user.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key});

  static const routeName = '/user-info';

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    return PageWrapper(
        title: 'Nutzerinformationen',
        simpleDesign: true,
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
                                "$backendURL/api/users/${user.id}/image",
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
                  user.username ?? '-',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
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
                        user.major ?? '-',
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
                        user.university ?? '-',
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
                        "E-Mail: ${user.email ?? '-'}",
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "Tel: ${user.mobile ?? '-'}",
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "Discord: ${user.discord ?? '-'}",
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
                        user.bio ?? '',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
    );
  }
}