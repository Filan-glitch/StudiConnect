import '../user.dart';
import 'actions.dart';
import 'app_state.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is! Action) return state;

  switch (action.type) {
    case ActionTypes.startTask:
      state.runningTasks++;
    case ActionTypes.stopTask:
      state.runningTasks--;
    case ActionTypes.setUser:
      state.user = User.fromApi(action.payload);
    case ActionTypes.updateUser:
      state.user?.update(
        name: action.payload['name'],
        course: action.payload['course'],
        university: action.payload['university'],
        bio: action.payload['bio'],
        contact: action.payload['contact'],
      );
  }

  return state;
}