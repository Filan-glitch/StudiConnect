import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:studiconnect/services/storage/secure_storage_provider.dart';

Future<void> saveCredentials(String userID, String sessionID) async {
  FlutterSecureStorage storage = secureStorage;
  await storage.write(key: "userID", value: userID);
  await storage.write(key: "sessionID", value: sessionID);
}

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

Future<void> saveAuthProviderType(String type) async {
  FlutterSecureStorage storage = secureStorage;
  storage.write(key: "authProviderType", value: type);
}

Future<String?> loadAuthProviderType() async {
  FlutterSecureStorage storage = secureStorage;
  return storage.read(key: "authProviderType");
}

Future<void> deleteCredentials() async {
  FlutterSecureStorage storage = secureStorage;
  await storage.delete(key: "userID");
  await storage.delete(key: "sessionID");
  await storage.delete(key: "authProviderType");
}