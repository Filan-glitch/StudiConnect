import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:studiconnect/main.dart';
import 'package:studiconnect/models/redux/actions.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/models/user.dart';
import 'package:studiconnect/controllers/api.dart';
import 'package:studiconnect/services/graphql/errors/api_exception.dart';
import 'package:studiconnect/services/graphql/user.dart' as service;
import 'package:studiconnect/services/rest/profile_image.dart' as rest_service;
import 'package:studiconnect/services/storage/credentials.dart' as storage;
import 'package:studiconnect/services/firebase/authentication.dart' as firebase;

import '../constants.dart';

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

  // backup messages for groups
  if (store.state.user?.groups != null) {
    result.groups = result.groups?.map((group) {
      final messages = store.state.user?.groups
          ?.firstWhere((element) => element.id == group.id, orElse: () => group)
          .messages;
      return group.update(messages: messages);
    }).toList();
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
    showToast(
        "Dein Profil konnte nicht aktualisiert werden. Du wirdst nun ausgeloggt.");
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
  try {
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
  } on ApiException catch (e) {
    showToast(e.message);
    return;
  } catch (e) {
    showToast("Dein Account konnte nicht gelöscht werden.");
    return;
  }

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
  Uint8List content;
  try {
    content = await file.readAsBytes();
  } catch (e) {
    showToast("Das Bild war fehlerhaft.");
    return;
  }

  try {
    await runRestApi(
        apiCall: () => rest_service.uploadProfileImage(content),
        parser: (result) => null).then((value) async {
      store.dispatch(
        Action(
          ActionTypes.setProfileImageAvailable,
          payload: true,
        ),
      );
      showToast("Profilbild erfolgreich hochgeladen.");
    });
  } on ApiException catch (e) {
    showToast(e.message);
    return;
  } catch (e) {
    showToast(e.toString());
    return;
  }

  await DefaultCacheManager()
      .removeFile("$backendURL/api/group/${store.state.user?.id}/image");
  await DefaultCacheManager()
      .downloadFile("$backendURL/api/group/${store.state.user?.id}/image");
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

  await DefaultCacheManager()
      .removeFile("$backendURL/api/group/${store.state.user?.id}/image");

  showToast(
      "Profilbild erfolgreich gelöscht. Evtl. liegt das Bild noch im Cache.");
}
