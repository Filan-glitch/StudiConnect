enum ActionTypes {
  startTask,
  stopTask,
  setUser,
  updateUser,
  updateSearchResults,
  updateSessionID,
}

class Action {
  ActionTypes type;
  dynamic payload;

  Action(this.type, {this.payload});
}
