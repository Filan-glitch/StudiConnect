import 'package:studiconnect/models/redux/actions.dart';
import 'package:studiconnect/models/redux/app_state.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is! Action) return state;

  switch (action.type) {
    case ActionTypes.clear:
      state = AppState();
    case ActionTypes.startTask:
      state.runningTasks++;
    case ActionTypes.stopTask:
      state.runningTasks--;
    case ActionTypes.setUser:
      state.user = action.payload;
    case ActionTypes.updateUser:
      state.user?.update(
        username: action.payload['username'],
        university: action.payload['university'],
        major: action.payload['major'],
        lat: action.payload['lat'],
        lon: action.payload['lon'],
        bio: action.payload['bio'],
        mobile: action.payload['mobile'],
        discord: action.payload['discord'],
      );
    case ActionTypes.updateGroup:
      state.user?.groups
          ?.firstWhere((element) => element.id == action.payload['id'])
          .update(
            title: action.payload['title'],
            description: action.payload['description'],
            module: action.payload['module'],
            lat: action.payload['lat'],
            lon: action.payload['lon'],
          );
    case ActionTypes.updateSessionID:
      state.sessionID = action.payload;
    case ActionTypes.updateSearchResults:
      state.searchResults = action.payload;
    case ActionTypes.updateAuthProviderType:
      state.authProviderType = action.payload;
    case ActionTypes.setProfileImageAvailable:
      state.profileImageAvailable = action.payload;
    case ActionTypes.setConnectionState:
      state.connected = action.payload;
  }

  return state;
}
