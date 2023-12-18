import '../models/redux/actions.dart';
import '../models/redux/store.dart';
import '../models/user.dart';
import 'api.dart';
import '../services/graphql/user.dart' as service;

Future<void> loadUserInfo() async {
  // TODO: load user id from shared prefs

  User? result = await runApiService(
    apiCall: () => service.loadMyUserInfo("TODO"),
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
    return;
  }

  store.dispatch(
    Action(
      ActionTypes.setUser,
      payload: result,
    ),
  );
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
    return;
  }

  store.dispatch(
    Action(
      ActionTypes.updateUser,
      payload: result,
    ),
  );
}
