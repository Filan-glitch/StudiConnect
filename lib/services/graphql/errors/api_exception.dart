/// Represents an API exception.
///
/// This class implements the [Exception] interface and provides a custom
/// exception type for handling API errors. It includes an optional error
/// message and an error code.
///
/// The [message] parameter is optional and defaults to a generic error message.
/// It represents the error message associated with the exception.
///
/// The [code] parameter is optional and represents the error code associated
/// with the exception.
class ApiException implements Exception {
  final String message;
  final int? code;

  /// The default error message to be used if no custom message is provided.
  static const String defaultMessage =
      "Es ist ein unbekannter Fehler aufgetreten.";

  /// Creates an [ApiException].
  ///
  /// The [message] parameter defaults to [defaultMessage] if not provided.
  /// The [code] parameter is optional.
  ApiException({
    this.message = defaultMessage,
    this.code,
  });
}