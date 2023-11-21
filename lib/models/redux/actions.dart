enum ActionTypes {
  startTask,
  stopTask,
}

class Action {
  ActionTypes type;
  dynamic payload;

  Action(this.type, {this.payload});
}