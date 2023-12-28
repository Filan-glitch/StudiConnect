import 'package:studiconnect/main.dart';
import 'package:studiconnect/models/redux/actions.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/models/user.dart';
import 'package:studiconnect/controllers/api.dart';
import 'package:studiconnect/services/graphql/user.dart' as service;
import 'package:studiconnect/services/storage/credentials.dart' as storage;

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
  User? result = await runApiService(
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
    parser: (result) => User.fromApi(
      result["user"],
    ),
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
    return;
  }

  store.dispatch(
    Action(
      ActionTypes.updateUser,
      payload: result,
    ),
  );
}
