import 'package:studiconnect/services/graphql/errors/input_error.dart';
import 'package:studiconnect/services/graphql/errors/internal_server_error.dart';
import 'package:studiconnect/services/graphql/errors/not_found_exception.dart';
import 'package:studiconnect/services/graphql/errors/connection_error.dart';
import 'package:studiconnect/services/graphql/errors/forbidden_error.dart';
import 'package:studiconnect/services/graphql/errors/unauthorized_error.dart';
import 'package:studiconnect/services/logger_provider.dart';

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
