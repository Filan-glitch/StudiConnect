/// This library contains the functions for user.
///
/// {@category CONTROLLERS}
library controllers.user;
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart' hide User;
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
import 'package:studiconnect/services/logger_provider.dart';
import 'package:studiconnect/services/rest/profile_image.dart' as rest_service;
import 'package:studiconnect/services/storage/credentials.dart' as storage;
import 'package:studiconnect/services/firebase/authentication.dart' as firebase;
import 'package:studiconnect/constants.dart';

/// Loads the user information from the storage and updates the state.
///
/// Returns a boolean indicating whether the operation was successful.
Future<bool> loadUserInfo() async {
  final Map<String, String> credentials = await storage.loadCredentials();

  // If there are no credentials, return false
  if (credentials.isEmpty) {
    return false;
  }

  final String userID = credentials['userID']!;

  final User? result = await runApiService(
    apiCall: () => service.loadMyUserInfo(userID),
    parser: (result) {
      final User u = User.fromApi(
        result['user'],
      );
      return u;
    },
  );

  // If the result is null, update the session ID in the state and navigate to the welcome page
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

  final String? authProviderType = await storage.loadAuthProviderType();
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

/// Updates the user profile with the provided information.
///
/// The [username], [university], [major], [lat], [lon], [bio], [mobile], and [discord] parameters are required and represent the new values of the corresponding properties of the user.
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
  final String? id = await runApiService(
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
      parser: (result) => result['updateProfile']['id'] as String
  );

  // If the ID is null, update the session ID in the state and navigate to the welcome page
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

  // Load the user information
  await loadUserInfo();
}

/// Deletes the user account.
///
/// The [credential] parameter is required and represents the credential of the user.
Future<void> deleteAccount(String credential) async {
  try {
    log('Deleting account from Firebase');
    if (store.state.authProviderType == 'email') {
      await firebase.deleteEmailAccount(credential);
    } else if (store.state.authProviderType == 'google') {
      await firebase.deleteGoogleAccount();
    }

    log('Deleting account from API');
    await runApiService(
      apiCall: () => service.deleteAccount(),
      shouldRethrow: true,
    );

  } on ApiException catch (e) {
    showToast(e.message);
    rethrow;
  } on FirebaseAuthException {
    rethrow;
  } catch (e) {
    showToast(e.toString());
    rethrow;
  }

  log('Deleting credentials from storage');
  await storage.deleteCredentials();

  showToast('Account erfolgreich gelöscht.');

  // Update the session ID in the state and navigate to the welcome page
  store.dispatch(
    Action(
      ActionTypes.clear,
    ),
  );
  navigatorKey.currentState!.pushNamedAndRemoveUntil(
    '/welcome',
    (route) => false,
  );
}

/// Uploads the provided profile image.
///
/// The [file] parameter is required and represents the image file to be uploaded.
Future<void> uploadProfileImage(XFile file) async {
  Uint8List content;
  try {
    content = await file.readAsBytes();
  } catch (e) {
    showToast('Das Bild war fehlerhaft.');
    return;
  }

  try {
    await runRestApi(
        apiCall: () => rest_service.uploadProfileImage(content),
        shouldRethrow: true
    );
  } on ApiException catch (e) {
    showToast(e.message);
    return;
  } catch (e) {
    showToast(e.toString());
    return;
  }

  // Update the profile image availability in the state
  store.dispatch(
    Action(
      ActionTypes.setProfileImageAvailable,
      payload: true,
    ),
  );

  showToast('Profilbild erfolgreich hochgeladen.');

  await DefaultCacheManager().removeFile(
      '$backendURL/api/group/${store.state.user?.id}/image');
  await DefaultCacheManager().downloadFile(
      '$backendURL/api/group/${store.state.user?.id}/image');
}

/// Deletes the profile image.
Future<void> deleteProfileImage() async {
  try {
    await runRestApi(
        apiCall: () => rest_service.deleteProfileImage(),
        shouldRethrow: true
    );
  } on ApiException catch (e) {
    showToast(e.message);
    return;
  } catch (e) {
    showToast(e.toString());
    return;
  }

  // Update the profile image availability in the state
  store.dispatch(
    Action(
      ActionTypes.setProfileImageAvailable,
      payload: false,
    ),
  );

  await DefaultCacheManager()
      .removeFile('$backendURL/api/group/${store.state.user?.id}/image');

  showToast(
      'Profilbild erfolgreich gelöscht. Evtl. liegt das Bild noch im Cache.');
}