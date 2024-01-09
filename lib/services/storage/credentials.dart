import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:studiconnect/services/logger_provider.dart';
import 'package:studiconnect/services/storage/secure_storage_provider.dart';

Future<void> saveCredentials(String userID, String sessionID) async {
  FlutterSecureStorage storage = secureStorage;
  log("Saving credentials");
  await storage.write(key: "userID", value: userID);
  log("Saved userID");
  await storage.write(key: "sessionID", value: sessionID);
  log("Saved sessionID");
}

Future<Map<String, String>> loadCredentials() async {
  FlutterSecureStorage storage = secureStorage;
  log("Loading credentials");
  String? userID = await storage.read(key: "userID");
  log("Loaded userID");
  String? sessionID = await storage.read(key: "sessionID");
  log("Loaded sessionID");

  if (userID == null || sessionID == null) {
    log("Credentials not found");
    return {};
  }

  log("Credentials found");
  return {
    "userID": userID,
    "sessionID": sessionID,
  };
}

Future<void> saveAuthProviderType(String type) async {
  FlutterSecureStorage storage = secureStorage;
  log("Saving auth provider type");
  storage.write(key: "authProviderType", value: type);
  log("Saved auth provider type");
}

Future<String?> loadAuthProviderType() async {
  FlutterSecureStorage storage = secureStorage;
  log("Loading auth provider type");
  var val = storage.read(key: "authProviderType");
  log("Loaded auth provider type");
  return val;
}

Future<void> deleteCredentials() async {
  FlutterSecureStorage storage = secureStorage;
  log("Deleting credentials");
  await storage.delete(key: "userID");
  log("Deleted userID");
  await storage.delete(key: "sessionID");
  log("Deleted sessionID");
  await storage.delete(key: "authProviderType");
  log("Deleted authProviderType");
}