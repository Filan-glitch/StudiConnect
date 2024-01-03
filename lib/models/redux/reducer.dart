/// This library is part of the Redux state management system. It contains the [appReducer] function.
///
/// {@category REDUX}
library models.redux.reducer;
import 'package:studiconnect/models/redux/actions.dart';
import 'package:studiconnect/models/redux/app_state.dart';

/// A function that reduces the application state based on the provided action.
///
/// This function takes the current state of the application and an action as input,
/// and returns the new state of the application after applying the action.
///
/// The [state] parameter is required and represents the current state of the application.
///
/// The [action] parameter is required and represents the action to be applied.
///
/// If the action is not an instance of the [Action] class, the function returns the current state without any changes.
///
/// Depending on the type of the action, the function updates the corresponding property of the state.
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
    case ActionTypes.updateGroup:
      state.user?.groups?.firstWhere((element) => element.id == action.payload['id']).update(
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