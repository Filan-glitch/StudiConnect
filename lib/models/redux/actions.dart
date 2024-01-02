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

class Action {
  ActionTypes type;
  dynamic payload;

  Action(this.type, {this.payload});
}
