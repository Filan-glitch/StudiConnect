/// This library provides authentication services for the application using Firebase.
///
/// {@category SERVICES}
library services.firebase.authentication;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oktoast/oktoast.dart';
import 'package:studiconnect/services/logger_provider.dart';

/// Signs in a user with the provided email and password.
///
/// Returns a Future that completes with the user's ID token if the sign in was successful.
Future<String?> signInWithEmailAndPassword(
    String email, String password) async {
  log('Signing in with email and password');
  final FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential? userCredential;

  log('Calling Firebase to sign in and get credentials');
  userCredential = await auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
  log('Got credentials from Firebase');

  return userCredential.user?.getIdToken();
}

/// Signs up a user with the provided email and password.
///
/// Returns a Future that completes with the user's ID token if the sign up was successful.
Future<String?> signUpWithEmailAndPassword(
    String email, String password) async {
  log('Signing up with email and password');
  final FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential? userCredential;

  log('Calling Firebase to create and account and get credentials');
  userCredential = await auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
  log('Got credentials from Firebase');

  return userCredential.user?.getIdToken();
}

/// Signs in a user with Google.
///
/// Returns a Future that completes with the user's ID token if the sign in was successful.
Future<Map?> signInWithGoogle() async {
  log('Signing in with Google');
  final FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential? userCredential;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  log('Requesting Google account sing in');
  final GoogleSignInAccount? googleSignInAccount;
  try {
    googleSignInAccount = await googleSignIn.signIn();
  } catch (e) {
    logWarning(e.toString());
    showToast('Es ist ein Fehler beim Anmelden aufgetreten');
    rethrow;
  }

  if (googleSignInAccount != null) {
    log('Google account sign in successful');
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    log('Getting credentials from Google');
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    log('Got credentials from Google');

    log('Calling Firebase to sign in and get credentials');
    userCredential = await auth.signInWithCredential(credential);
    log('Got credentials from Firebase');
  } else {
    log('Google account sign in failed');
    return null;
  }

  return {
    'idToken': await userCredential.user?.getIdToken(),
    'newUser': userCredential.additionalUserInfo?.isNewUser,
  };
}

/// Reauthenticates the current user with Google.
///
/// Returns a Future that completes with the user's ID token if the reauthentication was successful.
Future<AuthCredential> reauthenticateWithGoogle() async {
  log('Reauthenticating with Google');
  final GoogleSignIn googleSignIn = GoogleSignIn();

  log('Requesting Google account sing in');
  final GoogleSignInAccount? googleSignInAccount;
  try {
    googleSignInAccount = await googleSignIn.signIn();
  } catch (e) {
    logWarning(e.toString());
    showToast('Es ist ein Fehler beim Anmelden aufgetreten');
    rethrow;
  }

  if (googleSignInAccount != null) {
    log('Google account sign in successful');
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    log('Getting credentials from Google');
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    log('Got credentials from Google');

    return credential;
  } else {
    log('Google account sign in failed');
    throw Exception('Google account sign in failed');
  }
}

/// Signs out the current user.
///
/// If no user is signed in, nothing happens.
///
/// Returns a Future that completes when the sign out is finished.
///
/// The user is signed out from Firebase and Google.
Future<void> signOut() async {
  log('Signing out');
  if (FirebaseAuth.instance.currentUser == null) {
    log('No user signed in');
    return;
  }
  log('Signing out from Firebase and Google');
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();
  log('Signed out');
}

/// Sends a password reset email to the user.
///
/// The user can use the link in the email to reset their password.
Future<void> sendPasswordResetEmail(String email) async {
  log('Sending password reset email');
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  log('Sent password reset email');
}

/// Deletes the current user's email account.
///
/// The user must reauthenticate with their password before the account can be deleted.
Future<void> deleteEmailAccount(String password) async {
  try {
    log('Reauthenticating user');
    await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(
      EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email!,
        password: password,
      ),
    );
    log('Reauthenticated user');

    log('Deleting email account from Firebase');
    await FirebaseAuth.instance.currentUser?.delete();
    log('Deleted email account from Firebase');
  } catch (e) {
    logWarning(e.toString());
    showToast('Bitte überprüfen Sie Ihr Passwort');
  }
}

/// Deletes the current user's google auth account
///
/// The user must reauthenticate with their google account before the account can be deleted.
Future<void> deleteGoogleAccount() async {
  log('Reauthenticating user');
  await FirebaseAuth.instance.currentUser
      ?.reauthenticateWithCredential(await reauthenticateWithGoogle());
  log('Reauthenticated user');

  log('Deleting Google account from Firebase');
  await FirebaseAuth.instance.currentUser?.delete();
  log('Deleted Google account from Firebase');
}

/// Updates the current user's password.
///
/// The user must reauthenticate with their current password before the password can be updated.
Future<void> updatePassword(String oldPassword, String newPassword) async {
  try {
    log('Reauthenticating user');
    await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(
      EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email!,
        password: oldPassword,
      ),
    );
    log('Reauthenticated user');

    log('Updating password in Firebase');
    await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
    log('Updated password in Firebase');
  } catch (e) {
    logWarning(e.toString());
    rethrow;
  }
}