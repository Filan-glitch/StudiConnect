import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:auth_buttons/auth_buttons.dart' show AuthButtonStyle, EmailAuthButton, GoogleAuthButton;
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '/models/redux/app_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepeatController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool _isObscure = true;
  bool _isObscureRepeat = true;
  bool _emailButtonLoading = false;
  bool _googleButtonLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordRepeatController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  //Valid Password: Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character
  bool _validatePassword() {
    return _passwordController.text != _passwordRepeatController.text && RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$').hasMatch(_passwordController.text);
  }

  Future<UserCredential> registerWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // send id token to backend
    //     http.post(Uri.parse("http://10.0.2.2:8080/api/login"),
    //         body: """mutation login {
    //     login(token: "${googleAuth?.idToken}") {
    //         sessionID
    //     }
    // }""");

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> registerWithEmail() async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
  }


  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (BuildContext context, AppState state) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Werde Mitglied!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Benutzername',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Passwort',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: _passwordRepeatController,
                    obscureText: _isObscureRepeat,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Passwort wiederholen',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscureRepeat ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscureRepeat = !_isObscureRepeat;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                EmailAuthButton(
                  onPressed: () {
                    setState(() {
                      _emailButtonLoading = true;
                    });
                    setState(() {
                      _emailButtonLoading = false;
                    });
                  },
                  text: "Mit Email registrieren",
                  isLoading: _emailButtonLoading,
                  style: AuthButtonStyle(
                    textStyle: TextStyle(
                      fontFamily: GoogleFonts.kalam().fontFamily,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                GoogleAuthButton(
                  onPressed: () {
                    setState(() {
                      _googleButtonLoading = true;
                    });
                    setState(() {
                      _googleButtonLoading = false;
                    });
                  },
                  text: "Mit Google registrieren",
                  isLoading: _googleButtonLoading,
                  style: AuthButtonStyle(
                    textStyle: TextStyle(
                      fontFamily: GoogleFonts.kalam().fontFamily,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      }
    );
  }
}