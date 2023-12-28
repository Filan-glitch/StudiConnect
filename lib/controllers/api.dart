import 'dart:developer';

import 'package:oktoast/oktoast.dart';

import '../services/graphql/errors/api_exception.dart';
import '/models/redux/store.dart';
import '/models/redux/actions.dart' as redux;

Future<T?> runApiService<T>({
  required Future<Map<String, dynamic>?> Function() apiCall,
  required T Function(Map<String, dynamic> parser) parser,
  bool showLoading = true,
}) async {
  // Loading Screen
  if (showLoading) {
    store.dispatch(redux.Action(redux.ActionTypes.startTask, payload: null));
  }

  // API Call
  final Map<String, dynamic>? response;
  try {
    response = await apiCall();
  } on ApiException catch (e) {
    log("API Exception ${e.code}: ${e.message}");

    if (showLoading) {
      store.dispatch(redux.Action(redux.ActionTypes.stopTask));
    }

    showToast(e.message);
    return null;
  }

  // Parsing
  T? parsed;
  if (response != null) {
    try {
      parsed = parser(response);
    } catch (e) {
      log(e.toString());
      if (showLoading) {
        store.dispatch(redux.Action(redux.ActionTypes.stopTask));
      }

      showToast("Die Daten konnten nicht verarbeitet werden.");
      return null;
    }
  }

  if (showLoading) {
    store.dispatch(redux.Action(redux.ActionTypes.stopTask, payload: null));
  }

  return parsed;
}
