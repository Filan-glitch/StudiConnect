import 'package:shared_preferences/shared_preferences.dart';

/// Saves the user's credentials in shared preferences.
///
/// The [userID] and [sessionID] parameters are required.
/// This function does not return a value.
Future<void> saveCredentials(String userID, String sessionID) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("userID", userID);
  await prefs.setString("sessionID", sessionID);
}

/// Loads the user's credentials from shared preferences.
///
/// Returns a Future that completes with a Map containing the user's credentials.
/// If the credentials are not found, the Map is empty.
Future<Map<String, String>> loadCredentials() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userID = prefs.getString("userID");
  String? sessionID = prefs.getString("sessionID");

  if (userID == null || sessionID == null) {
    return {};
  }

  return {
    "userID": userID,
    "sessionID": sessionID,
  };
}

/// Saves the type of the authentication provider in shared preferences.
///
/// The [type] parameter is required.
/// This function does not return a value.
Future<void> saveAuthProviderType(String type) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("authProviderType", type);
}

/// Loads the type of the authentication provider from shared preferences.
///
/// Returns a Future that completes with the type of the authentication provider.
/// If the type is not found, the Future completes with null.
Future<String?> loadAuthProviderType() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("authProviderType");
}

/// Deletes the user's credentials and the type of the authentication provider from shared preferences.
///
/// This function does not return a value.
Future<void> deleteCredentials() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("userID");
  await prefs.remove("sessionID");
  await prefs.remove("authProviderType");
}