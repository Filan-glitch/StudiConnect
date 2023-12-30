import 'package:redux/redux.dart';
import 'package:studiconnect/models/redux/reducer.dart';
import 'package:studiconnect/models/redux/app_state.dart';

/// The global store for the application.
///
/// This store is created using the [Store] class from the redux package. It uses the [appReducer]
/// function to reduce the state of the application based on the dispatched actions.
///
/// The initial state of the store is an instance of the [AppState] class with its default values.
final Store<AppState> store = Store<AppState>(
  appReducer,
  initialState: AppState(),
);