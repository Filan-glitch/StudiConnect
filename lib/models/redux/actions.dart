enum ActionTypes {
  startTask,
  stopTask,
  setUser,
  updateUser,
  updateSearchResults,
  updateSessionID,
  updateAuthProviderType,
  setProfileImageAvailable,
}

class Action {
  ActionTypes type;
  dynamic payload;

  Action(this.type, {this.payload});
}
