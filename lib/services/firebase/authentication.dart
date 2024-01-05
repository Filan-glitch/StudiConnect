/// This library provides authentication services for the application using Firebase.
///
/// {@category SERVICES}
library services.firebase.authentication;

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oktoast/oktoast.dart';

/// Signs in a user with the provided email and password.
///
/// The [email] and [password] parameters are required.
/// Returns a Future that completes with the user's ID token if the sign in was successful.
Future<String?> signInWithEmailAndPassword(
    String email, String password) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential? userCredential;

  userCredential = await auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

  return userCredential.user?.getIdToken();
}

/// Signs up a user with the provided email and password.
///
/// The [email] and [password] parameters are required.
/// Returns a Future that completes with the user's ID token if the sign up was successful.
Future<String?> signUpWithEmailAndPassword(
    String email, String password) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential? userCredential;

  userCredential = await auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );

  return userCredential.user?.getIdToken();
}

/// Sends a password reset email to the user.
///
/// The [email] parameter is required.
Future<void> triggerPasswordReset(String email) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  await auth.sendPasswordResetEmail(email: email);
}

/// Signs in a user with Google.
///
/// Returns a Future that completes with the user's ID token if the sign in was successful.
Future<String?> signInWithGoogle() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential? userCredential;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    userCredential = await auth.signInWithCredential(credential);
  } else {
    return null;
  }

  return userCredential.user?.getIdToken();
}

/// Signs out the current user.
Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();
}

/// Sends a password reset email to the user.
///
/// The [email] parameter is required.
Future<void> sendPasswordResetEmail(String email) async {
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}

/// Deletes the current user's email account.
///
/// The [password] parameter is required.
Future<void> deleteEmailAccount(String password) async {
  try {
    await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(
      EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email!,
        password: password,
      ),
    );

    await FirebaseAuth.instance.currentUser?.delete();
  } catch (e) {
    log(e.toString());
    showToast("Bitte überprüfen Sie Ihr Passwort");
  }
}

/// Deletes the current user's Google account.
Future<void> deleteGoogleAccount() async {
  await FirebaseAuth.instance.currentUser
      ?.reauthenticateWithProvider(GoogleAuthProvider());

  await FirebaseAuth.instance.currentUser?.delete();
}

/// Updates the current user's password.
///
/// The [oldPassword] and [newPassword] parameters are required.
Future<void> updatePassword(String oldPassword, String newPassword) async {
  try {
    await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(
      EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email!,
        password: oldPassword,
      ),
    );

    await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
  } catch (e) {
    log(e.toString());
    showToast("Bitte überprüfen Sie Ihr Passwort");
  }
}