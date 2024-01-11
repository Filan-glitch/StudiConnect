/// This library provides functions for managing user credentials and the authentication provider type in secure storage.
///
/// {@category SERVICES}
library services.storage.credentials;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:studiconnect/services/logger_provider.dart';
import 'package:studiconnect/services/storage/secure_storage_provider.dart';

/// Saves the user's credentials in secure storage.
///
/// The [userID] and [sessionID] parameters are required.
/// This function does not return a value.
///
/// [userID] is the unique identifier for the user.
/// [sessionID] is the unique identifier for the current session.
Future<void> saveCredentials(String userID, String sessionID) async {
  final FlutterSecureStorage storage = secureStorage;
  log('Saving credentials');
  await storage.write(key: 'userID', value: userID);
  log('Saved userID');
  await storage.write(key: 'sessionID', value: sessionID);
  log('Saved sessionID');
}

/// Loads the user's credentials from secure storage.
///
/// Returns a Future that completes with a Map containing the user's credentials.
/// If the credentials are not found, the Map is empty.
Future<Map<String, String>> loadCredentials() async {
  final FlutterSecureStorage storage = secureStorage;
  log('Loading credentials');
  final String? userID = await storage.read(key: 'userID');
  log('Loaded userID');
  final String? sessionID = await storage.read(key: 'sessionID');
  log('Loaded sessionID');

  if (userID == null || sessionID == null) {
    log('Credentials not found');
    return {};
  }

  log('Credentials found');
  return {
    'userID': userID,
    'sessionID': sessionID,
  };
}

/// Saves the type of the authentication provider in secure storage.
///
/// The [type] parameter is required.
/// This function does not return a value.
///
/// [type] is the type of the authentication provider.
Future<void> saveAuthProviderType(String type) async {
  final FlutterSecureStorage storage = secureStorage;
  log('Saving auth provider type');
  storage.write(key: 'authProviderType', value: type);
  log('Saved auth provider type');
}

/// Loads the type of the authentication provider from secure storage.
///
/// Returns a Future that completes with the type of the authentication provider.
/// If the type is not found, the Future completes with null.
Future<String?> loadAuthProviderType() async {
  final FlutterSecureStorage storage = secureStorage;
  log('Loading auth provider type');
  final val = storage.read(key: 'authProviderType');
  log('Loaded auth provider type');
  return val;
}

/// Deletes the user's credentials and the type of the authentication provider from secure storage.
///
/// This function does not return a value.
Future<void> deleteCredentials() async {
  final FlutterSecureStorage storage = secureStorage;
  log('Deleting credentials');
  await storage.delete(key: 'userID');
  log('Deleted userID');
  await storage.delete(key: 'sessionID');
  log('Deleted sessionID');
  await storage.delete(key: 'authProviderType');
  log('Deleted authProviderType');
}