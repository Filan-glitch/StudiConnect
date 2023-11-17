import 'package:redux/redux.dart';
import '/models/redux/reducer.dart';
import 'app_state.dart';

final Store<AppState> store = Store<AppState>(
  appReducer,
  initialState: AppState(),
);