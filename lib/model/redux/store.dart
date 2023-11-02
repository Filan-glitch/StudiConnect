import 'package:redux/redux.dart';

import 'app_state.dart';
import 'reducer.dart';

final Store<AppState> store = Store<AppState>(
  appReducer,
  initialState: AppState(),
);
