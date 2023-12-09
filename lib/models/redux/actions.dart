enum ActionTypes {
  startTask,
  stopTask,
  setUser,
  updateUser,
}

class Action {
  ActionTypes type;
  dynamic payload;

  Action(this.type, {this.payload});
}