import 'actions.dart';
import 'app_state.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is! Action) return state;

  switch (action.type) {
    case ActionTypes.startTask:
      // TODO: Handle this case.
    case ActionTypes.stopTask:
      // TODO: Handle this case.
  }

  return state;
}