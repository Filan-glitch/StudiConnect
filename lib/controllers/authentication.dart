import 'package:oktoast/oktoast.dart';

import 'package:studiconnect/main.dart';
import 'package:studiconnect/models/redux/actions.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/services/firebase/authentication.dart' as firebase;
import 'package:studiconnect/services/graphql/authentication.dart' as service;
import 'package:studiconnect/services/storage/credentials.dart' as storage;
import 'package:studiconnect/controllers/api.dart';
import 'package:studiconnect/controllers/user.dart';

/// Loads the user's credentials from shared preferences.
///
/// If the credentials are not found, the function returns without doing anything.
/// If the credentials are found, the function dispatches an action to update the session ID in the store,
/// loads the user's information, and navigates to the home page.
Future<void> loadCredentials() async {
  Map<String, String> credentials = await storage.loadCredentials();

  if (!credentials.containsKey("sessionID")) {
    return;
  }

  String sessionID = credentials["sessionID"]!;

  store.dispatch(
    Action(
      ActionTypes.updateSessionID,
      payload: sessionID,
    ),
  );

  bool success = await loadUserInfo();

  if (!success) {
    return;
  }

  navigatorKey.currentState!.pushNamedAndRemoveUntil(
    '/home',
    (route) => false,
  );
}

/// Signs in a user with Google.
///
/// If the sign in is successful, the function dispatches an action to update the session ID in the store,
/// loads the user's information, navigates to the home page, and saves the user's credentials in shared preferences.
/// If the sign in is not successful, the function shows a toast with an error message.
Future<void> signInWithGoogle() async {
  String? idToken = await firebase.signInWithGoogle();

  if (idToken == null) {
    showToast("Anmeldung mit Google fehlgeschlagen");
    return;
  }

  Map<String, dynamic>? session = await runApiService(
    apiCall: () => service.login(idToken),
    parser: (result) => result["login"],
  );

  if (session == null) {
    showToast("Anmeldung mit Google fehlgeschlagen");
    return;
  }

  String sessionID = session["sessionID"];
  String userID = session["user"];

  store.dispatch(
    Action(
      ActionTypes.updateSessionID,
      payload: sessionID,
    ),
  );

  await storage.saveAuthProviderType("google");

  loadUserInfo();

  navigatorKey.currentState!.pushNamedAndRemoveUntil(
    '/home',
    (route) => false,
  );

  storage.saveCredentials(userID, sessionID);
}

/// Signs in a user with email and password.
///
/// If the sign in is successful, the function dispatches an action to update the session ID in the store,
/// loads the user's information, navigates to the home page, and saves the user's credentials in shared preferences.
/// If the sign in is not successful, the function shows a toast with an error message.
Future<void> signInWithEmailAndPassword(String email, String password) async {
  String? idToken = await firebase.signInWithEmailAndPassword(email, password);

  if (idToken == null) {
    showToast("Anmeldung mit E-Mail fehlgeschlagen");
    return;
  }

  Map<String, dynamic>? session = await runApiService(
    apiCall: () => service.login(idToken),
    parser: (result) => result["login"],
  );

  if (session == null) {
    showToast("Anmeldung mit E-Mail fehlgeschlagen");
    return;
  }

  String sessionID = session["sessionID"];
  String userID = session["sessionID"];

  store.dispatch(
    Action(
      ActionTypes.updateSessionID,
      payload: sessionID,
    ),
  );

  await storage.saveAuthProviderType("email");

  loadUserInfo();

  navigatorKey.currentState!.pushNamedAndRemoveUntil(
    '/home',
    (route) => false,
  );

  storage.saveCredentials(userID, sessionID);
}

/// Signs up a user with email and password.
///
/// If the sign up is successful, the function dispatches an action to update the session ID in the store,
/// loads the user's information, navigates to the home page, and saves the user's credentials in shared preferences.
/// If the sign up is not successful, the function shows a toast with an error message.
Future<void> signUpWithEmailAndPassword(String email, String password) async {
  String? idToken = await firebase.signUpWithEmailAndPassword(email, password);

  if (idToken == null) {
    showToast("Registrierung fehlgeschlagen");
    return;
  }

  Map<String, dynamic>? session = await runApiService(
    apiCall: () => service.login(idToken),
    parser: (result) => result["login"],
  );

  if (session == null) {
    showToast("Registrierung fehlgeschlagen");
    return;
  }

  String sessionID = session["sessionID"];
  String userID = session["sessionID"];

  store.dispatch(
    Action(
      ActionTypes.updateSessionID,
      payload: sessionID,
    ),
  );

  await storage.saveAuthProviderType("email");

  loadUserInfo();

  navigatorKey.currentState!.pushNamedAndRemoveUntil(
    '/home',
    (route) => false,
  );

  storage.saveCredentials(userID, sessionID);
}

/// Signs out the current user.
///
/// The function signs out the user from Firebase, logs out the user from the GraphQL service,
/// dispatches an action to update the session ID in the store, navigates to the welcome page,
/// and deletes the user's credentials from shared preferences.
Future<void> signOut() async {
  await firebase.signOut();
  await runApiService(
    apiCall: () => service.logout(),
    parser: (result) => null,
  );

  store.dispatch(
    Action(
      ActionTypes.updateSessionID,
      payload: null,
    ),
  );

  navigatorKey.currentState!.pushNamedAndRemoveUntil(
    '/welcome',
    (route) => false,
  );

  storage.deleteCredentials();
}

/// Sends a password reset email to the user.
///
/// The [email] parameter is required and represents the email of the user.
/// The function sends a password reset email to the user and shows a toast with a success message.
Future<void> triggerPasswordReset(String email) async {
  await firebase.sendPasswordResetEmail(email);
  showToast(
      "Ein Link zum Zurücksetzen des Passworts wurde an Ihre E-Mail gesendet.");
}

/// Updates the password of the current user.
///
/// The [oldPassword] and [newPassword] parameters are required and represent the old and new passwords of the user.
/// The function updates the user's password and shows a toast with a success message.
Future<void> updatePassword(String oldPassword, String newPassword) async {
  await firebase.updatePassword(oldPassword, newPassword);
  showToast("Passwort erfolgreich aktualisiert");
}