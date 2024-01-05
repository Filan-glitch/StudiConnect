/// This library is part of the Redux state management system. It contains the [ActionTypes] enum and the [Action] class.
///
/// {@category REDUX}
library models.redux.actions;

/// Enum representing the different types of actions that can be dispatched in the application.
///
/// The different types of actions include:
/// - startTask: Represents the action of starting a task.
/// - stopTask: Represents the action of stopping a task.
/// - setUser: Represents the action of setting the user.
/// - updateUser: Represents the action of updating the user.
/// - updateGroup: Represents the action of updating the group.
/// - updateSearchResults: Represents the action of updating the search results.
/// - updateSessionID: Represents the action of updating the session ID.
/// - updateAuthProviderType: Represents the action of updating the auth provider type.
/// - setProfileImageAvailable: Represents the action of setting the profile image availability.
/// - setConnectionState: Represents the action of setting the connection state.
enum ActionTypes {
  startTask,
  stopTask,
  setUser,
  updateUser,
  updateGroup,
  updateSearchResults,
  updateSessionID,
  updateAuthProviderType,
  setProfileImageAvailable,
  setConnectionState,
}

/// Class representing an action that can be dispatched in the application.
///
/// An action consists of a type, which is one of the [ActionTypes], and an optional payload.
///
/// The [type] parameter is required and represents the type of the action.
///
/// The [payload] parameter is optional and represents the payload of the action.
class Action {
  ActionTypes type;
  dynamic payload;

  Action(this.type, {this.payload});
}