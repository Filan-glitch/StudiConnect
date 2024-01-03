import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:studiconnect/main.dart';
import 'package:studiconnect/models/redux/actions.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/models/user.dart';
import 'package:studiconnect/controllers/api.dart';
import 'package:studiconnect/services/graphql/user.dart' as service;
import 'package:studiconnect/services/rest/profile_image.dart' as rest_service;
import 'package:studiconnect/services/storage/credentials.dart' as storage;
import 'package:studiconnect/services/firebase/authentication.dart' as firebase;

Future<bool> loadUserInfo() async {
  Map<String, String> credentials = await storage.loadCredentials();

  if (credentials.isEmpty) {
    return false;
  }

  String userID = credentials["userID"]!;

  User? result = await runApiService(
    apiCall: () => service.loadMyUserInfo(userID),
    parser: (result) {
      User u = User.fromApi(
        result["user"],
      );
      return u;
    },
  );

  if (result == null) {
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

    return false;
  }

  store.dispatch(
    Action(
      ActionTypes.setUser,
      payload: result,
    ),
  );

  String? authProviderType = await storage.loadAuthProviderType();
  store.dispatch(
    Action(
      ActionTypes.updateAuthProviderType,
      payload: authProviderType,
    ),
  );

  store.dispatch(Action(
    ActionTypes.setProfileImageAvailable,
    payload: await rest_service.profileImageAvailable(),
  ));

  return true;
}

Future<void> updateProfile(
  String username,
  String university,
  String major,
  double lat,
  double lon,
  String bio,
  String mobile,
  String discord,
) async {
  String? id = await runApiService(
      apiCall: () => service.updateProfile(
            username,
            university,
            major,
            lat,
            lon,
            bio,
            mobile,
            discord,
          ),
      parser: (result) => result["updateProfile"]["id"] as String);

  if (id == null) {
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
    return;
  }

  await loadUserInfo();
}

Future<void> deleteAccount(String credential) async {
  await Future.wait([
    runApiService(
      apiCall: () => service.deleteAccount(),
      parser: (result) => null,
    ),
    storage.deleteCredentials(),
    if (store.state.authProviderType == "email")
      firebase.deleteEmailAccount(credential),
    if (store.state.authProviderType == "google")
      firebase.deleteGoogleAccount(),
  ]);

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
}

Future<void> uploadProfileImage(XFile file) async {
  Uint8List content = await file.readAsBytes();

  await runRestApi(
      apiCall: () => rest_service.uploadProfileImage(content),
      parser: (result) => null);

  store.dispatch(
    Action(
      ActionTypes.setProfileImageAvailable,
      payload: true,
    ),
  );

  showToast("Profilbild erfolgreich hochgeladen.");
}

Future<void> deleteProfileImage() async {
  await runRestApi(
      apiCall: () => rest_service.deleteProfileImage(),
      parser: (result) => null);

  store.dispatch(
    Action(
      ActionTypes.setProfileImageAvailable,
      payload: false,
    ),
  );

  showToast(
      "Profilbild erfolgreich gelöscht. Evtl. liegt das Bild noch im Cache.");
}
