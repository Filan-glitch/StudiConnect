/// This file contains the [processHttpStatusCodes] function.
///
/// {@category SERVICES}
library services.rest.api;

import 'package:studiconnect/models/redux/actions.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/services/errors/input_error.dart';
import 'package:studiconnect/services/errors/internal_server_error.dart';
import 'package:studiconnect/services/errors/not_found_exception.dart';
import 'package:studiconnect/services/errors/connection_error.dart';
import 'package:studiconnect/services/errors/forbidden_error.dart';
import 'package:studiconnect/services/errors/unauthorized_error.dart';

/// Processes HTTP status codes and throws the appropriate exception.
///
/// This function takes an HTTP status code and an optional custom error message,
/// and throws the corresponding exception based on the status code.
///
/// The [statusCode] parameter is required and represents the HTTP status code.
///
/// The [customMessage] parameter is optional and represents a custom error message.
/// If provided, it will be used as the error message for the thrown exception.
/// If not provided, a default error message will be used.
///
/// This function does not return a value. If the status code corresponds to a known
/// error, it throws an exception. If the status code does not correspond to a known
/// error, the function returns normally.
void processHttpStatusCodes(int statusCode, {String? customMessage}) {
  if (statusCode < 100) {
    // If the status code is less than 100, throw a ConnectionException.
    store.dispatch(
      Action(
        ActionTypes.setConnectionState,
        payload: false,
      ),
    );
    throw ConnectionException(code: statusCode);
  } else if (statusCode == 401) {
    // If the status code is 401, throw an UnauthorizedException.
    throw UnauthorizedException(
      code: statusCode,
      message: customMessage ?? UnauthorizedException.defaultMessage,
    );
  } else if (statusCode == 403) {
    // If the status code is 403, throw a ForbiddenException.
    throw ForbiddenException(
      code: statusCode,
      message: customMessage ?? ForbiddenException.defaultMessage,
    );
  } else if (statusCode == 404) {
    // If the status code is 404, throw a NotFoundException.
    throw NotFoundException(
      code: statusCode,
      message: customMessage ?? NotFoundException.defaultMessage,
    );
  } else if (statusCode == 502 || statusCode == 504) {
    // If the status code is 502 or 504, throw a ConnectionException.
    throw ConnectionException(code: statusCode);
  } else if (statusCode >= 500) {
    // If the status code is 500 or greater, throw an InternalServerException.
    throw InternalServerException(
      code: statusCode,
      message: customMessage ?? InternalServerException.defaultMessage,
    );
  } else if (statusCode >= 400) {
    // If the status code is 400 or greater, throw an InputException.
    throw InputException(
      code: statusCode,
      message: customMessage ?? InputException.defaultMessage,
    );
  }
}
