/// This library contains functions for authentication.
///
/// {@category CONTROLLERS}
library controllers.authentication;

import 'package:oktoast/oktoast.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:studiconnect/main.dart';
import 'package:studiconnect/models/redux/actions.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/services/firebase/authentication.dart' as firebase;
import 'package:studiconnect/services/graphql/authentication.dart' as service;
import 'package:studiconnect/services/graphql/errors/api_exception.dart';
import 'package:studiconnect/services/logger_provider.dart';
import 'package:studiconnect/services/storage/credentials.dart' as storage;
import 'package:studiconnect/controllers/api.dart';
import 'package:studiconnect/controllers/user.dart';

/// Loads the user's credentials from shared preferences.
///
/// If the credentials are not found, the function returns without doing anything.
/// If the credentials are found, the function dispatches an action to update the session ID in the store,
/// loads the user's information, and navigates to the home page.
Future<void> loadCredentials() async {
  log('Loading credentials from storage');
  final Map<String, String> credentials = await storage.loadCredentials();
  log('Loaded credentials from storage');

  if (!credentials.containsKey('sessionID')) {
    log('No credentials found');
    FlutterNativeSplash.remove();
    return;
  }

  log('Session found');
  final String sessionID = credentials['sessionID']!;

  store.dispatch(
    Action(
      ActionTypes.updateSessionID,
      payload: sessionID,
    ),
  );

  log('Loading user info');
  final bool success = await loadUserInfo();

  if (!success) {
    log('User info could not be loaded');
    FlutterNativeSplash.remove();
    return;
  }
  log('User info loaded');

  log('Navigating to home screen');
  navigatorKey.currentState!.pushNamedAndRemoveUntil(
    '/home',
    (route) => false,
  );
  FlutterNativeSplash.remove();
}

/// Signs in a user with Google.
///
/// If the sign in is successful, the function dispatches an action to update the session ID in the store,
/// loads the user's information, navigates to the home page, and saves the user's credentials in shared preferences.
/// If the sign in is not successful, the function shows a toast with an error message.
Future<bool?> signInWithGoogle() async {
  final Map? result = await firebase.signInWithGoogle();
  final String? idToken = result?['idToken'];
  final bool? isNewUser = result?['newUser'];

  if (idToken == null) {
    log('Google sign in failed');
    return null;
  }

  log('Calling API to sign in with Google');
  final Map<String, dynamic>? session = await runApiService(
    apiCall: () => service.login(idToken),
    parser: (result) => result['login'],
  );

  if (session == null) {
    log('API call failed');
    return null;
  }

  log('API call successful');
  final String sessionID = session['sessionID'];
  final String userID = session['user'];

  store.dispatch(
    Action(
      ActionTypes.updateSessionID,
      payload: sessionID,
    ),
  );

  log('Saving credentials');
  await storage.saveAuthProviderType('google');
  await storage.saveCredentials(userID, sessionID);

  log('Loading user info');
  loadUserInfo();

  log('Navigating to home screen');
  navigatorKey.currentState!.pushNamedAndRemoveUntil(
    '/home',
    (route) => false,
  );

  return isNewUser;
}

/// Signs in a user with email and password.
///
/// If the sign in is successful, the function dispatches an action to update the session ID in the store,
/// loads the user's information, navigates to the home page, and saves the user's credentials in shared preferences.
/// If the sign in is not successful, the function shows a toast with an error message.
Future<void> signInWithEmailAndPassword(String email, String password) async {
  log('Signing in with email and password');
  final String? idToken = await firebase.signInWithEmailAndPassword(email, password);

  if (idToken == null) {
    log('Email sign in failed');
    return;
  }

  log('Calling API to sign in with email and password');
  final Map<String, dynamic>? session = await runApiService(
    apiCall: () => service.login(idToken),
    parser: (result) => result['login'],
  );

  if (session == null) {
    log('API call failed');
    return;
  }

  log('API call successful');
  final String sessionID = session['sessionID'];
  final String userID = session['user'];

  store.dispatch(
    Action(
      ActionTypes.updateSessionID,
      payload: sessionID,
    ),
  );

  log('Saving credentials');
  await storage.saveAuthProviderType('email');
  await storage.saveCredentials(userID, sessionID);

  log('Loading user info');
  loadUserInfo();

  log('Navigating to home screen');
  navigatorKey.currentState!.pushNamedAndRemoveUntil(
    '/home',
    (route) => false,
  );
}

/// Signs up a user with email and password.
///
/// If the sign up is successful, the function dispatches an action to update the session ID in the store,
/// loads the user's information, navigates to the home page, and saves the user's credentials in shared preferences.
/// If the sign up is not successful, the function shows a toast with an error message.
Future<void> signUpWithEmailAndPassword(String email, String password) async {
  log('Signing up with email and password');
  final String? idToken = await firebase.signUpWithEmailAndPassword(email, password);

  if (idToken == null) {
    logWarning('Email sign up failed');
    return;
  }

  log('Calling API to sign up with email and password');
  final Map<String, dynamic>? session = await runApiService(
    apiCall: () => service.login(idToken),
    parser: (result) => result['login'],
  );

  if (session == null) {
    logWarning('API call failed');
    return;
  }

  log('API call successful');
  final String sessionID = session['sessionID'];
  final String userID = session['user'];

  store.dispatch(
    Action(
      ActionTypes.updateSessionID,
      payload: sessionID,
    ),
  );

  log('Saving credentials');
  await storage.saveAuthProviderType('email');
  await storage.saveCredentials(userID, sessionID);

  log('Loading user info');
  loadUserInfo();

  log('Navigating to home screen');
  navigatorKey.currentState!.pushNamedAndRemoveUntil(
    '/home',
    (route) => false,
  );
}

/// Signs in a user as a guest.
///
/// If the sign in is successful, the function dispatches an action to update the session ID in the store,
/// loads the user's information, navigates to the home page, and saves the user's credentials in shared preferences.
/// If the sign in is not successful, the function shows a toast with an error message.
Future<void> signInAsGuest() async {
  log('Signing in as guest');
  final Map<String, dynamic>? session = await runApiService(
    apiCall: () => service.loginAsGuest(),
    parser: (result) => result['loginAsGuest'],
  );

  if (session == null) {
    log('API call failed');
    return;
  }

  log('API call successful');
  final String sessionID = session['sessionID'];
  final String userID = session['user'];

  store.dispatch(
    Action(
      ActionTypes.updateSessionID,
      payload: sessionID,
    ),
  );

  log('Saving credentials');
  await storage.saveAuthProviderType('guest');
  await storage.saveCredentials(userID, sessionID);

  log('Loading user info');
  loadUserInfo();

  log('Navigating to home screen');
  navigatorKey.currentState!.pushNamedAndRemoveUntil(
    '/home',
    (route) => false,
  );
}

/// Signs out the current user.
///
/// The function signs out the user from Firebase, logs out the user from the GraphQL service,
/// dispatches an action to update the session ID in the store, navigates to the welcome page,
/// and deletes the user's credentials from shared preferences.
Future<void> signOut() async {
  log('Calling API to sign out');
  try {
    await runApiService(
      apiCall: () => service.logout(),
      shouldRethrow: true,
    );
  } on ApiException catch (e) {
    //TODO: Ensure that the user is logged out even if the API call fails
    showToast(e.message);
    return;
  } catch (e) {
    //TODO: Same here
    showToast(e.toString());
    return;
  }

  log('Signing out');
  await firebase.signOut();

  log('Clearing credentials');
  store.dispatch(
    Action(
      ActionTypes.clear,
    ),
  );
  storage.deleteCredentials();

  log('Navigating to welcome screen');
  navigatorKey.currentState!.pushNamedAndRemoveUntil(
    '/welcome',
    (route) => false,
  );
}

/// Sends a password reset email to the user.
///
/// The [email] parameter is required and represents the email of the user.
/// The function sends a password reset email to the user and shows a toast with a success message.
Future<void> triggerPasswordReset(String email) async {
  log('Triggering password reset');
  await firebase.sendPasswordResetEmail(email);
  showToast('Ein Link zum Zurücksetzen des Passworts wurde an Ihre E-Mail gesendet.');
}

/// Updates the password of the current user.
///
/// The [oldPassword] and [newPassword] parameters are required and represent the old and new passwords of the user.
/// The function updates the user's password and shows a toast with a success message.
Future<void> updatePassword(String oldPassword, String newPassword) async {
  log('Updating password');
  await firebase.updatePassword(oldPassword, newPassword);
  showToast('Passwort erfolgreich aktualisiert');
}