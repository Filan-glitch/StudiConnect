/// This file contains the [processHttpStatusCodes] function which is used to handle HTTP status codes.
///
/// {@category SERVICES}
library services.rest.api;

import 'package:studiconnect/services/graphql/errors/input_error.dart';
import 'package:studiconnect/services/graphql/errors/internal_server_error.dart';
import 'package:studiconnect/services/graphql/errors/not_found_exception.dart';
import 'package:studiconnect/services/graphql/errors/connection_error.dart';
import 'package:studiconnect/services/graphql/errors/forbidden_error.dart';
import 'package:studiconnect/services/graphql/errors/unauthorized_error.dart';
import 'package:studiconnect/services/logger_provider.dart';

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
  log('HTTP Status Code: $statusCode');
  if (statusCode < 100) {
    log('Informational status code');
    throw ConnectionException(code: statusCode);
  } else if (statusCode == 401) {
    log('Operation was unauthorized');
    throw UnauthorizedException(
      code: statusCode,
      message: customMessage ?? UnauthorizedException.defaultMessage,
    );
  } else if (statusCode == 403) {
    log('Operation was forbidden');
    throw ForbiddenException(
      code: statusCode,
      message: customMessage ?? ForbiddenException.defaultMessage,
    );
  } else if (statusCode == 404) {
    log('Ressource was not found');
    throw NotFoundException(
      code: statusCode,
      message: customMessage ?? NotFoundException.defaultMessage,
    );
  } else if (statusCode == 502 || statusCode == 504) {
    log('Gateway connection error');
    throw ConnectionException(code: statusCode);
  } else if (statusCode >= 500) {
    log('Internal server error');
    throw InternalServerException(
      code: statusCode,
      message: customMessage ?? InternalServerException.defaultMessage,
    );
  } else if (statusCode >= 400) {
    log('Input error');
    throw InputException(
      code: statusCode,
      message: customMessage ?? InputException.defaultMessage,
    );
  } else {
    log('Unhandeled status code, should consider adding it to the list of handeled status codes');
  }
}
