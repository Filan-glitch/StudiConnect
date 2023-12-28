import 'package:studiconnect/models/redux/actions.dart';
import 'package:studiconnect/models/redux/app_state.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is! Action) return state;

  switch (action.type) {
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
    case ActionTypes.updateSessionID:
      state.sessionID = action.payload;
    case ActionTypes.updateSearchResults:
      state.searchResults = action.payload;
  }

  return state;
}
