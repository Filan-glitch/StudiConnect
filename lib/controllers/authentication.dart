import 'package:oktoast/oktoast.dart';

import 'package:studiconnect/main.dart';
import 'package:studiconnect/models/redux/actions.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/services/firebase/authentication.dart' as firebase;
import 'package:studiconnect/services/graphql/authentication.dart' as service;
import 'package:studiconnect/services/storage/credentials.dart' as storage;
import 'package:studiconnect/controllers/api.dart';
import 'package:studiconnect/controllers/user.dart';

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

  loadUserInfo();

  navigatorKey.currentState!.pushNamedAndRemoveUntil(
    '/home',
    (route) => false,
  );

  storage.saveCredentials(userID, sessionID);
}

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

  loadUserInfo();

  navigatorKey.currentState!.pushNamedAndRemoveUntil(
    '/home',
    (route) => false,
  );

  storage.saveCredentials(userID, sessionID);
}

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

  loadUserInfo();

  navigatorKey.currentState!.pushNamedAndRemoveUntil(
    '/home',
    (route) => false,
  );

  storage.saveCredentials(userID, sessionID);
}

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

Future<void> triggerPasswordReset(String email) async {
  await firebase.sendPasswordResetEmail(email);
  showToast(
      "Ein Link zum Zurücksetzen des Passworts wurde an Ihre E-Mail gesendet.");
}
