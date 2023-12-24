import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:studiconnect/pages/join_group_requests_page.dart';
import 'package:studiconnect/pages/user_info_page.dart';

import '/pages/group_info_page.dart';
import '/pages/create_and_edit_group_page.dart';
import '/pages/settings_page.dart';
import '/pages/edit_profile_page.dart';
import '/pages/further_registration_page.dart';
import '/models/redux/store.dart';
import '/themes/light_theme.dart';
import '/themes/dark_theme.dart';
import '/pages/registration_page.dart';
import '/pages/login_help_page.dart';
import '/pages/welcome_page.dart';
import '/firebase_options.dart';
import '/pages/login_page.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'StudiConnect',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('de', 'DE'),
        ],
        localizationsDelegates: const [
          // ... app-specific localization delegate[s] here
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        navigatorKey: navigatorKey,
        initialRoute: '/welcome',
        routes: {
          '/home': (context) => const HomePage(),
          '/welcome': (context) => const WelcomePage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/login-help': (context) => const LoginHelpPage(),
          '/further-registration': (context) => const FurtherRegistrationPage(),
          '/edit-profile': (context) => const EditProfilePage(),
          '/settings': (context) => const SettingsPage(),
          CreateAndEditGroupPage.routeName: (context) => const CreateAndEditGroupPage(),
          GroupInfoPage.routeName: (context) => const GroupInfoPage(),
          JoinGroupRequestsPage.routeName: (context) => const JoinGroupRequestsPage(),
          UserInfoPage.routeName: (context) => const UserInfoPage(),
        },
      ),
    );
  }
}
