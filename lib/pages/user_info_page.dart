import 'package:flutter/material.dart';
import 'package:studiconnect/widgets/avatar_picture.dart';
import 'package:studiconnect/models/user.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    return PageWrapper(
      title: 'Nutzerinformationen',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 15),
                child: AvatarPicture(
                  id: user.id,
                  type: Type.user,
                  radius: 65,
                  loadingCircleStrokeWidth: 5.0,
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
                      user.major ?? '-',
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
                      user.university ?? '-',
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
