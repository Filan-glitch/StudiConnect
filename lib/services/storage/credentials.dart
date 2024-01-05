/// This library provides functions for managing user credentials and the authentication provider type in secure storage.
///
/// {@category SERVICES}
library services.storage.credentials;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:studiconnect/services/storage/secure_storage_provider.dart';

/// Saves the user's credentials in secure storage.
///
/// The [userID] and [sessionID] parameters are required.
/// This function does not return a value.
///
/// [userID] is the unique identifier for the user.
/// [sessionID] is the unique identifier for the current session.
Future<void> saveCredentials(String userID, String sessionID) async {
  FlutterSecureStorage storage = secureStorage;
  await storage.write(key: "userID", value: userID);
  await storage.write(key: "sessionID", value: sessionID);
}

/// Loads the user's credentials from secure storage.
///
/// Returns a Future that completes with a Map containing the user's credentials.
/// If the credentials are not found, the Map is empty.
Future<Map<String, String>> loadCredentials() async {
  FlutterSecureStorage storage = secureStorage;
  String? userID = await storage.read(key: "userID");
  String? sessionID = await storage.read(key: "sessionID");

  if (userID == null || sessionID == null) {
    return {};
  }

  return {
    "userID": userID,
    "sessionID": sessionID,
  };
}

/// Saves the type of the authentication provider in secure storage.
///
/// The [type] parameter is required.
/// This function does not return a value.
///
/// [type] is the type of the authentication provider.
Future<void> saveAuthProviderType(String type) async {
  FlutterSecureStorage storage = secureStorage;
  storage.write(key: "authProviderType", value: type);
}

/// Loads the type of the authentication provider from secure storage.
///
/// Returns a Future that completes with the type of the authentication provider.
/// If the type is not found, the Future completes with null.
Future<String?> loadAuthProviderType() async {
  FlutterSecureStorage storage = secureStorage;
  return storage.read(key: "authProviderType");
}

/// Deletes the user's credentials and the type of the authentication provider from secure storage.
///
/// This function does not return a value.
Future<void> deleteCredentials() async {
  FlutterSecureStorage storage = secureStorage;
  await storage.delete(key: "userID");
  await storage.delete(key: "sessionID");
  await storage.delete(key: "authProviderType");
}