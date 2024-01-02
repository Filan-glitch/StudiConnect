import 'package:studiconnect/models/redux/actions.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/services/graphql/errors/input_error.dart';
import 'package:studiconnect/services/graphql/errors/internal_server_error.dart';
import 'package:studiconnect/services/graphql/errors/not_found_exception.dart';
import 'package:studiconnect/services/graphql/errors/connection_error.dart';
import 'package:studiconnect/services/graphql/errors/forbidden_error.dart';
import 'package:studiconnect/services/graphql/errors/unauthorized_error.dart';

void processHttpStatusCodes(int statusCode, {String? customMessage}) {
  if (statusCode < 100) {
    store.dispatch(
      Action(
        ActionTypes.setConnectionState,
        payload: false,
      ),
    );
    throw ConnectionException(code: statusCode);
  } else if (statusCode == 401) {
    throw UnauthorizedException(
      code: statusCode,
      message: customMessage ?? UnauthorizedException.defaultMessage,
    );
  } else if (statusCode == 403) {
    throw ForbiddenException(
      code: statusCode,
      message: customMessage ?? ForbiddenException.defaultMessage,
    );
  } else if (statusCode == 404) {
    throw NotFoundException(
      code: statusCode,
      message: customMessage ?? NotFoundException.defaultMessage,
    );
  } else if (statusCode == 502 || statusCode == 504) {
    throw ConnectionException(code: statusCode);
  } else if (statusCode >= 500) {
    throw InternalServerException(
      code: statusCode,
      message: customMessage ?? InternalServerException.defaultMessage,
    );
  } else if (statusCode >= 400) {
    throw InputException(
      code: statusCode,
      message: customMessage ?? InputException.defaultMessage,
    );
  }
}
