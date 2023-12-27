import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveCredentials(String userID, String sessionID) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("userID", userID);
  await prefs.setString("sessionID", sessionID);
}

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

Future<void> deleteCredentials() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("userID");
  await prefs.remove("sessionID");
}
