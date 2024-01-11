/// This library contains the [ApiException] class.
///
/// {@category EXCEPTIONS}
library services.error.api_exception;

/// Represents an API exception.
///
/// This class implements the [Exception] interface and provides a custom
/// exception type for handling API errors. It includes an optional error
/// message and an error code.
class ApiException implements Exception {

  /// The error message associated with the exception.
  final String message;

  /// The error code associated with the exception.
  final int? code;

  /// The default error message to be used if no custom message is provided.
  static const String defaultMessage =
      'Es ist ein unbekannter Fehler aufgetreten.';

  /// Creates an [ApiException].
  ///
  /// The [message] parameter defaults to [defaultMessage] if not provided.
  /// The [code] parameter is optional.
  ApiException({
    this.message = defaultMessage,
    this.code,
  });
}
