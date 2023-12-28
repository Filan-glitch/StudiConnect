import 'package:redux/redux.dart';
import 'package:studiconnect/models/redux/reducer.dart';
import 'package:studiconnect/models/redux/app_state.dart';

final Store<AppState> store = Store<AppState>(
  appReducer,
  initialState: AppState(),
);