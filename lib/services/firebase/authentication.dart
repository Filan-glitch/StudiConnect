import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();
}

Future<void> sendPasswordResetEmail(String email) async {
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}
