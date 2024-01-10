import 'package:studiconnect/services/graphql/errors/api_exception.dart';

class ConnectionException extends ApiException {
  ConnectionException({
    super.message = defaultMessage,
    super.code = 0,
  });

  static const String defaultMessage =
      'Es konnte keine Verbindung zum Server hergestellt werden.';
}
