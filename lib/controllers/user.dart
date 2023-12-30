library controllers.user;
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

/// Loads the user information from the storage and updates the state.
///
/// Returns a boolean indicating whether the operation was successful.
Future<bool> loadUserInfo() async {
  // Load the credentials from the storage
  Map<String, String> credentials = await storage.loadCredentials();

  // If there are no credentials, return false
  if (credentials.isEmpty) {
    return false;
  }

  // Get the user ID from the credentials
  String userID = credentials["userID"]!;

  // Load the user information from the API
  User? result = await runApiService(
    apiCall: () => service.loadMyUserInfo(userID),
    parser: (result) {
      User u = User.fromApi(
        result["user"],
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

  // Update the user in the state
  store.dispatch(
    Action(
      ActionTypes.setUser,
      payload: result,
    ),
  );

  // Load the auth provider type from the storage and update it in the state
  String? authProviderType = await storage.loadAuthProviderType();
  store.dispatch(
    Action(
      ActionTypes.updateAuthProviderType,
      payload: authProviderType,
    ),
  );

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
  // Update the profile in the API
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
  // Delete the account in the API, delete the credentials from the storage, and delete the account in Firebase
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

  // Update the session ID in the state and navigate to the welcome page
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

/// Uploads the provided profile image.
///
/// The [file] parameter is required and represents the image file to be uploaded.
Future<void> uploadProfileImage(XFile file) async {
  // Read the file content
  Uint8List content = await file.readAsBytes();

  // Upload the profile image to the API
  await runRestApi(
      apiCall: () => rest_service.uploadProfileImage(content),
      parser: (result) => null);

  // Update the profile image availability in the state
  store.dispatch(
    Action(
      ActionTypes.setProfileImageAvailable,
      payload: true,
    ),
  );

  // Show a toast message
  showToast("Profilbild erfolgreich hochgeladen.");
}

/// Deletes the profile image.
Future<void> deleteProfileImage() async {
  // Delete the profile image from the API
  await runRestApi(
      apiCall: () => rest_service.deleteProfileImage(),
      parser: (result) => null);

  // Update the profile image availability in the state
  store.dispatch(
    Action(
      ActionTypes.setProfileImageAvailable,
      payload: false,
    ),
  );

  // Show a toast message
  showToast(
      "Profilbild erfolgreich gelöscht. Evtl. liegt das Bild noch im Cache.");
}