import 'package:oktoast/oktoast.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:studiconnect/main.dart';
import 'package:studiconnect/models/redux/actions.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/services/firebase/authentication.dart' as firebase;
import 'package:studiconnect/services/graphql/authentication.dart' as service;
import 'package:studiconnect/services/logger_provider.dart';
import 'package:studiconnect/services/storage/credentials.dart' as storage;
import 'package:studiconnect/controllers/api.dart';
import 'package:studiconnect/controllers/user.dart';

Future<void> loadCredentials() async {
  log("Loading credentials from storage");
  Map<String, String> credentials = await storage.loadCredentials();
  log("Loaded credentials from storage");

  if (!credentials.containsKey("sessionID")) {
    log("No credentials found");
    FlutterNativeSplash.remove();
    return;
  }

  log("Session found");
  String sessionID = credentials["sessionID"]!;

  store.dispatch(
    Action(
      ActionTypes.updateSessionID,
      payload: sessionID,
    ),
  );

  log("Loading user info");
  bool success = await loadUserInfo();

  if (!success) {
    log("User info could not be loaded");
    FlutterNativeSplash.remove();
    return;
  }
  log("User info loaded");

  log("Navigating to home screen");
  navigatorKey.currentState!.pushNamedAndRemoveUntil(
    '/home',
    (route) => false,
  );
  FlutterNativeSplash.remove();
}

Future<bool?> signInWithGoogle() async {
  log("Signing in with Google");
  Map? result = await firebase.signInWithGoogle();
  String? idToken = result?["idToken"];
  bool? isNewUser = result?["newUser"];

  if (idToken == null) {
    log("Google sign in failed");
    showToast("Anmeldung mit Google fehlgeschlagen");
    return null;
  }

  log("Calling API to sign in with Google");
  Map<String, dynamic>? session = await runApiService(
    apiCall: () => service.login(idToken),
    parser: (result) => result["login"],
  );

  if (session == null) {
    log("API call failed");
    showToast("Anmeldung mit Google fehlgeschlagen");
    return null;
  }

  log("API call successful");
  String sessionID = session["sessionID"];
  String userID = session["user"];

  store.dispatch(
    Action(
      ActionTypes.updateSessionID,
      payload: sessionID,
    ),
  );

  log("Saving credentials");
  await storage.saveAuthProviderType("google");
  await storage.saveCredentials(userID, sessionID);

  log("Loading user info");
  loadUserInfo();

  log("Navigating to home screen");
  navigatorKey.currentState!.pushNamedAndRemoveUntil(
    '/home',
    (route) => false,
  );

  return isNewUser;
}

Future<void> signInWithEmailAndPassword(String email, String password) async {
  log("Signing in with email and password");
  String? idToken = await firebase.signInWithEmailAndPassword(email, password);

  if (idToken == null) {
    log("Email sign in failed");
    showToast("Anmeldung mit E-Mail fehlgeschlagen");
    return;
  }

  log("Calling API to sign in with email and password");
  Map<String, dynamic>? session = await runApiService(
    apiCall: () => service.login(idToken),
    parser: (result) => result["login"],
  );

  if (session == null) {
    log("API call failed");
    showToast("Anmeldung mit E-Mail fehlgeschlagen");
    return;
  }

  log("API call successful");
  String sessionID = session["sessionID"];
  String userID = session["user"];

  store.dispatch(
    Action(
      ActionTypes.updateSessionID,
      payload: sessionID,
    ),
  );

  log("Saving credentials");
  await storage.saveAuthProviderType("email");
  await storage.saveCredentials(userID, sessionID);

  log("Loading user info");
  loadUserInfo();

  log("Navigating to home screen");
  navigatorKey.currentState!.pushNamedAndRemoveUntil(
    '/home',
    (route) => false,
  );
}

Future<void> signUpWithEmailAndPassword(String email, String password) async {
  log("Signing up with email and password");
  String? idToken = await firebase.signUpWithEmailAndPassword(email, password);

  if (idToken == null) {
    log("Email sign up failed");
    showToast("Registrierung fehlgeschlagen");
    return;
  }

  log("Calling API to sign up with email and password");
  Map<String, dynamic>? session = await runApiService(
    apiCall: () => service.login(idToken),
    parser: (result) => result["login"],
  );

  if (session == null) {
    log("API call failed");
    showToast("Registrierung fehlgeschlagen");
    return;
  }

  log("API call successful");
  String sessionID = session["sessionID"];
  String userID = session["user"];

  store.dispatch(
    Action(
      ActionTypes.updateSessionID,
      payload: sessionID,
    ),
  );

  log("Saving credentials");
  await storage.saveAuthProviderType("email");
  await storage.saveCredentials(userID, sessionID);

  log("Loading user info");
  loadUserInfo();

  log("Navigating to home screen");
  navigatorKey.currentState!.pushNamedAndRemoveUntil(
    '/home',
    (route) => false,
  );
}

Future<void> signInAsGuest() async {
  log("Signing in as guest");
  Map<String, dynamic>? session = await runApiService(
    apiCall: () => service.loginAsGuest(),
    parser: (result) => result["loginAsGuest"],
  );

  if (session == null) {
    log("API call failed");
    showToast("Anmeldung fehlgeschlagen");
    return;
  }

  log("API call successful");
  String sessionID = session["sessionID"];
  String userID = session["user"];

  store.dispatch(
    Action(
      ActionTypes.updateSessionID,
      payload: sessionID,
    ),
  );

  log("Saving credentials");
  await storage.saveAuthProviderType("guest");
  await storage.saveCredentials(userID, sessionID);

  log("Loading user info");
  loadUserInfo();

  log("Navigating to home screen");
  navigatorKey.currentState!.pushNamedAndRemoveUntil(
    '/home',
    (route) => false,
  );
}

Future<void> signOut() async {
  log("Signing out");
  await firebase.signOut();

  log("Calling API to sign out");
  await runApiService(
    apiCall: () => service.logout(),
    parser: (result) => null,
  );

  log("Clearing credentials");
  store.dispatch(
    Action(
      ActionTypes.clear,
    ),
  );
  storage.deleteCredentials();

  log("Navigating to welcome screen");
  navigatorKey.currentState!.pushNamedAndRemoveUntil(
    '/welcome',
    (route) => false,
  );
}

Future<void> triggerPasswordReset(String email) async {
  log("Triggering password reset");
  await firebase.sendPasswordResetEmail(email);
  showToast("Ein Link zum Zurücksetzen des Passworts wurde an Ihre E-Mail gesendet.");
}

Future<void> updatePassword(String oldPassword, String newPassword) async {
  log("Updating password");
  await firebase.updatePassword(oldPassword, newPassword);
  showToast("Passwort erfolgreich aktualisiert");
}
