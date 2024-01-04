import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oktoast/oktoast.dart';

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

Future<void> triggerPasswordReset(String email) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  await auth.sendPasswordResetEmail(email: email);
}

Future<Map?> signInWithGoogle() async {
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

  return {
    "idToken": await userCredential.user?.getIdToken(),
    "newUser": userCredential.additionalUserInfo?.isNewUser,
  };
}

Future<void> signOut() async {
  if (FirebaseAuth.instance.currentUser == null) {
    return;
  }
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();
}

Future<void> sendPasswordResetEmail(String email) async {
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}

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

Future<void> deleteGoogleAccount() async {
  await FirebaseAuth.instance.currentUser
      ?.reauthenticateWithProvider(GoogleAuthProvider());

  await FirebaseAuth.instance.currentUser?.delete();
}

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
