import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:oktoast/oktoast.dart';
import 'package:studiconnect/pages/join_group_requests_page.dart';
import 'package:studiconnect/pages/password_change_page.dart';
import 'package:studiconnect/pages/user_info_page.dart';
import 'package:studiconnect/pages/group_info_page.dart';
import 'package:studiconnect/pages/create_and_edit_group_page.dart';
import 'package:studiconnect/pages/settings_page.dart';
import 'package:studiconnect/pages/edit_profile_page.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/themes/light_theme.dart';
import 'package:studiconnect/themes/dark_theme.dart';
import 'package:studiconnect/pages/registration_page.dart';
import 'package:studiconnect/pages/password_reset_page.dart';
import 'package:studiconnect/firebase_options.dart';
import 'package:studiconnect/pages/login_page.dart';
import 'package:studiconnect/controllers/authentication.dart';
import 'package:studiconnect/pages/home_page.dart';
import 'package:studiconnect/pages/welcome_page.dart';

import 'pages/delete_account_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // setup
  loadCredentials();

  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: OKToast(
        position: ToastPosition.bottom,
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
            '/login-help': (context) => PasswordResetPage(),
            '/edit-profile': (context) => const EditProfilePage(),
            '/settings': (context) => const SettingsPage(),
            '/delete-account': (context) => DeleteAccountPage(),
            '/update-password': (context) => const PasswordChangePage(),
            CreateAndEditGroupPage.routeName: (context) =>
                const CreateAndEditGroupPage(),
            GroupInfoPage.routeName: (context) => const GroupInfoPage(),
            JoinGroupRequestsPage.routeName: (context) =>
                const JoinGroupRequestsPage(),
            UserInfoPage.routeName: (context) => const UserInfoPage(),
          },
        ),
      ),
    );
  }
}
