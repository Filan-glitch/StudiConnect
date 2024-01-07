import 'package:studiconnect/services/logger_provider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:studiconnect/services/graphql/errors/api_exception.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/models/redux/actions.dart' as redux;

Future<T?> runApiService<T>({
  required Future<Map<String, dynamic>?> Function() apiCall,
  required T Function(Map<String, dynamic> parser) parser,
  bool showLoading = true,
}) async {
  // Loading Screen
  if (showLoading) {
    log("Starting Loading Screen");
    store.dispatch(redux.Action(redux.ActionTypes.startTask));
  }

  // API Call
  final Map<String, dynamic>? response;
  try {
    log("Starting API Call");
    response = await apiCall();
    log("API Call Finished");
  } on ApiException catch (e) {
    logWarning("API Exception ${e.code}: ${e.message}");

    if (showLoading) {
      log("Stopping Loading Screen");
      store.dispatch(redux.Action(redux.ActionTypes.stopTask));
    }

    showToast(e.message);
    return null;
  }

  // Parsing
  T? parsed;
  if (response != null) {
    try {
      log("Starting Parsing");
      parsed = parser(response);
      log("Parsing Finished");
    } catch (e) {
      logError(e.toString(), e as Error);
      if (showLoading) {
        log("Stopping Loading Screen");
        store.dispatch(redux.Action(redux.ActionTypes.stopTask));
      }

      showToast("Die Daten konnten nicht verarbeitet werden.");
      return null;
    }
  }

  if (showLoading) {
    log("Stopping Loading Screen");
    store.dispatch(redux.Action(redux.ActionTypes.stopTask));
  }

  return parsed;
}

Future<T?> runRestApi<T>({
  required Future<dynamic> Function() apiCall,
  required T Function(dynamic parser) parser,
  bool showLoading = true,
}) async {
  // Loading Screen
  if (showLoading) {
    log("Starting Loading Screen");
    store.dispatch(redux.Action(redux.ActionTypes.startTask));
  }

  // API Call
  final Map<String, dynamic>? response;
  try {
    log("Starting API Call");
    response = await apiCall();
    log("API Call Finished");
  } on ApiException catch (e) {
    logWarning("API Exception ${e.code}: ${e.message}");

    if (showLoading) {
      log("Stopping Loading Screen");
      store.dispatch(redux.Action(redux.ActionTypes.stopTask));
    }

    showToast(e.message);
    return null;
  }

  // Parsing
  T? parsed;
  if (response != null) {
    try {
      log("Starting Parsing");
      parsed = parser(response);
      log("Parsing Finished");
    } catch (e) {
      logWarning(e.toString());
      if (showLoading) {
        log("Stopping Loading Screen");
        store.dispatch(redux.Action(redux.ActionTypes.stopTask));
      }

      showToast("Die Daten konnten nicht verarbeitet werden.");
      return null;
    }
  }

  if (showLoading) {
    log("Stopping Loading Screen");
    store.dispatch(redux.Action(redux.ActionTypes.stopTask));
  }

  return parsed;
}
