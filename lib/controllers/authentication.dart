import 'package:oktoast/oktoast.dart';

import '../models/redux/actions.dart';
import '../models/redux/store.dart';
import '../services/firebase/authentication.dart' as firebase;
import '../services/graphql/authentication.dart' as service;
import 'api.dart';

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
  String userID = session["sessionID"];

  store.dispatch(
    Action(
      ActionTypes.updateSessionID,
      payload: sessionID,
    ),
  );

  // TODO: save sessionID and userID to shared prefs
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
}

Future<void> sendPasswordResetEmail(String email) async {
  await firebase.sendPasswordResetEmail(email);
  showToast("Passwort zurücksetzen E-Mail wurde gesendet");
}
