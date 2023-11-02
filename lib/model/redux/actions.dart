enum ActionType {
  defaultAction,
}

class Action {
  ActionType type;
  dynamic payload;

  Action(this.type, {this.payload});
}
