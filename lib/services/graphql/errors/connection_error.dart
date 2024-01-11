/// This library contains the [ConnectionException] class.
///
/// {@category EXCEPTIONS}
library services.error.connection_error;

import 'package:studiconnect/services/graphql/errors/api_exception.dart';

/// Represents a connection exception.
///
/// This class extends the [ApiException] class and provides a custom
/// exception type for handling connection errors. It includes a default error
/// message and a default error code.
///
/// The [message] parameter is optional and defaults to a connection error message.
/// It represents the error message associated with the exception.
///
/// The [code] parameter is optional and defaults to 0. It represents the error code associated
/// with the exception.
class ConnectionException extends ApiException {
  ConnectionException({
    super.message = defaultMessage,
    super.code = 0,
  });

  /// The default error message to be used if no custom message is provided.
  /// It indicates that a connection to the server could not be established.
  static const String defaultMessage =
      'Es konnte keine Verbindung zum Server hergestellt werden.';
}
