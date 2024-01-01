/// This library contains functions for executing API calls.
///
/// {@category CONTROLLERS}
library controllers.api;

import 'dart:developer';
import 'package:oktoast/oktoast.dart';
import 'package:studiconnect/services/errors/api_exception.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/models/redux/actions.dart' as redux;

/// Executes an API service and handles loading, API call, and parsing.
///
/// This function takes an API call and a parser function as input, and optionally a flag for showing a loading screen.
/// It dispatches actions to start and stop a loading task, executes the API call, and parses the response.
///
/// The [apiCall] parameter is required and should be a function that makes an API call and returns a Future that completes with a Map.
///
/// The [parser] parameter is required and should be a function that takes a Map and returns a parsed result.
///
/// The [showLoading] parameter is optional and defaults to true. If set to true, a loading task will be started before the API call and stopped after the parsing.
///
/// Returns a Future that completes with the parsed result if the API call and parsing were successful. If an error occurred, the Future completes with null.
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

/// Executes a REST API service and handles loading, API call, and parsing.
///
/// This function takes an API call and a parser function as input, and optionally a flag for showing a loading screen.
/// It dispatches actions to start and stop a loading task, executes the API call, and parses the response.
///
/// The [apiCall] parameter is required and should be a function that makes an API call and returns a Future that completes with a dynamic result.
///
/// The [parser] parameter is required and should be a function that takes a dynamic result and returns a parsed result.
///
/// The [showLoading] parameter is optional and defaults to true. If set to true, a loading task will be started before the API call and stopped after the parsing.
///
/// Returns a Future that completes with the parsed result if the API call and parsing were successful. If an error occurred, the Future completes with null.
Future<T?> runRestApi<T>({
  required Future<dynamic> Function() apiCall,
  required T Function(dynamic parser) parser,
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
