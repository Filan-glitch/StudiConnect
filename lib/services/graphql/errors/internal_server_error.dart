/// This library contains the [InternalServerException] class.
///
/// {@category EXCEPTIONS}
library services.errors.internal_server_error;

import 'package:studiconnect/services/graphql/errors/api_exception.dart';

/// Represents an internal server exception.
///
/// This class extends the [ApiException] class and provides a custom
/// exception type for handling internal server errors. It includes a default error
/// message and a default error code.
///
/// The [message] parameter is optional and defaults to an internal server error message.
/// It represents the error message associated with the exception.
///
/// The [code] parameter is optional and defaults to 500. It represents the error code associated
/// with the exception.
class InternalServerException extends ApiException {
  InternalServerException({
    super.message = defaultMessage,
    super.code = 500,
  });

  /// The default error message to be used if no custom message is provided.
  /// It indicates that an error occurred on the server.
  static const String defaultMessage =
      'Auf dem Server ist ein Fehler aufgetreten.';
}
