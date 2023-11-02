import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'firebase_options.dart';
import 'model/redux/app_state.dart';
import 'model/redux/store.dart';
import 'pages/login_page.dart';
import 'themes/dark_theme.dart';
import 'themes/light_theme.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'StudiConnect',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        supportedLocales: const [Locale('en', 'US'), Locale('de', 'DE')],
        home: const LoginPage(),
      ),
    );
  }
}
