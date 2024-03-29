import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:studiconnect/pages/chat_page.dart';
import 'package:studiconnect/pages/join_group_requests_page.dart';
import 'package:studiconnect/pages/password_change_page.dart';
import 'package:studiconnect/pages/user_info_page.dart';
import 'package:studiconnect/pages/group_info_page.dart';
import 'package:studiconnect/pages/create_and_edit_group_page.dart';
import 'package:studiconnect/pages/settings_page.dart';
import 'package:studiconnect/pages/edit_profile_page.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/services/logger_provider.dart';
import 'package:studiconnect/themes/light_theme.dart';
import 'package:studiconnect/themes/dark_theme.dart';
import 'package:studiconnect/pages/register_page.dart';
import 'package:studiconnect/pages/password_reset_page.dart';
import 'package:studiconnect/firebase_options.dart';
import 'package:studiconnect/pages/login_page.dart';
import 'package:studiconnect/controllers/authentication.dart';
import 'package:studiconnect/pages/home_page.dart';
import 'package:studiconnect/pages/welcome_page.dart';
import 'package:studiconnect/pages/delete_account_page.dart';

/// The main function of the application.
///
/// This function is responsible for initializing Firebase, setting up error handling,
/// loading user credentials, and starting the Flutter application.
Future<void> main() async {
  // Log the start of the application and the mode it's running in.
  log('Starting...');
  log('Running in ${kDebugMode ? 'debug' : 'release'} mode');
  log('Running on ${defaultTargetPlatform.toString().split('.').last}');

  // Initialize Widgets Binding and Firebase.
  log('Initializing Widgets Binding...');
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  log('Initializing Firebase...');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set up error handling for Flutter and the platform.
  FlutterError.onError = (errorDetails) {
    if (errorDetails.library == 'image resource service' &&
        errorDetails.exception.toString().contains('404')) {
      log('Suppressed cachedNetworkImage Exception');
      return;
    }
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
    return true;
  };

  // Load user credentials and start the Flutter application.
  log('Setting up...');
  loadCredentials();

  runApp(const MyApp());
}

/// The global navigator key.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// The main widget of the application.
///
/// This widget is a [StatelessWidget] that sets up the Redux store, toast notifications,
/// localization, navigation, and routes for the application.
class MyApp extends StatelessWidget {
  /// The Constructor of the [MyApp] class.
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
            '/chat': (context) => const ChatPage(),
            '/edit-profile': (context) => const EditProfilePage(),
            '/settings': (context) => const SettingsPage(),
            '/delete-account': (context) => DeleteAccountPage(),
            '/update-password': (context) => PasswordChangePage(),
            '/create-and-edit-group': (context) =>
                const CreateAndEditGroupPage(),
            '/group-info': (context) => const GroupInfoPage(),
            '/join-group-requests': (context) => const JoinGroupRequestsPage(),
            '/user-info': (context) => const UserInfoPage(),
          },
        ),
      ),
    );
  }
}