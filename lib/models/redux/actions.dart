enum ActionTypes {
  clear,
  startTask,
  stopTask,
  setupDone,
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
