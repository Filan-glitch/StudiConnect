import '/models/redux/store.dart';
import '/models/redux/actions.dart' as redux;

Future<T?> runApiService<T>({
  required Future<Map<String, dynamic>?> Function() apiCall,
  required T Function(Map<String, dynamic> parser) parser,
  bool showLoading = true,
}) async {
  // Loading Screen
  if (showLoading) {
    store.dispatch(redux.Action(
      redux.ActionTypes.startTask,
      payload: null
    ));
  }

  // API Call
  final Map<String, dynamic>? response;
  try {
    response = await apiCall();
  } catch (e) {
    //TODO: Error Handling

    if (showLoading) {
      store.dispatch(redux.Action(redux.ActionTypes.stopTask));
    }

    return null;
  }

  // Parsing
  T? parsed;
  if(response != null) {
    try {
      parsed = parser(response);
    } catch (e) {
      //TODO: Error Handling
    }
  }

  if (showLoading) {
    store.dispatch(redux.Action(
        redux.ActionTypes.stopTask,
        payload: null
    ));
  }

  return parsed;
}