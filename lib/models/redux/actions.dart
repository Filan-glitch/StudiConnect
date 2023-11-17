enum ActionTypes {
 basicEvent,
}

class Action {
  ActionTypes type;
  dynamic payload;

  Action(this.type, {this.payload});
}