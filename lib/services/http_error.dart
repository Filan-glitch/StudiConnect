/// This library contains the [ApiException] class and the [ErrorCategory] enum.
///
/// {@category EXCEPTIONS}
library service.http_error;

/// Represents an API exception.
///
/// This class implements the [Exception] interface and provides a set of predefined exceptions
/// that can be used to represent different types of API errors.
///
/// Each predefined exception is a static constant and has a specific error message associated with it.
class ApiException implements Exception {
  /// Represents a client error.
  ///
  /// This error is thrown when the client sends incorrect data or the app is outdated.
  static ApiException clientError =
      const ApiException('Die Daten sind falsch oder die App ist veraltet.');

  /// Represents a server error.
  ///
  /// This error is thrown when an error occurs on the server.
  static ApiException serverError =
      const ApiException('Auf dem Server ist ein Fehler aufgetreten.');

  /// Represents a proxy error.
  ///
  /// This error is thrown when the server is not reachable.
  static ApiException proxyError =
      const ApiException('Der Server ist nicht erreichbar.');

  /// Represents an authorization error.
  ///
  /// This error is thrown when the user needs to re-authenticate.
  static ApiException notAuthorized =
      const ApiException('Bitte melde dich erneut an.');

  /// Represents a not found error.
  ///
  /// This error is thrown when the requested data could not be found.
  static ApiException notFound =
      const ApiException('Die Daten konnten nicht gefunden werden.');

  /// Represents a forbidden error.
  ///
  /// This error is thrown when the user does not have permission to view the requested data.
  static ApiException forbidden =
      const ApiException('Du hast keine Berechtigung, diese Daten einzusehen.');

  /// Represents a deprecated error.
  ///
  /// This error is thrown when the API interface seems to be outdated.
  static ApiException deprecated =
      const ApiException('Die Schnittstelle scheint veraltet zu sein.');

  /// Represents a connection error.
  ///
  /// This error is thrown when a connection could not be established.
  static ApiException connectionError =
      const ApiException('Es konnte keine Verbindung hergestellt werden.');

  /// Represents an unknown error.
  ///
  /// This error is thrown when an unknown error occurs.
  static ApiException unknown =
      const ApiException('Es ist ein unbekannter Fehler aufgetreten.');

  /// Creates an [ApiException].
  ///
  /// The [message] parameter must not be null and represents the error message.
  const ApiException(
    this.message,
  );

  /// The error message.
  final String message;
}

/// Represents the category of an error.
///
/// This enum is used to categorize errors into different types.
enum ErrorCategory {
  /// Represents a client error.
  client,

  /// Represents a server error.
  server,

  /// Represents a connection error.
  connection,

  /// Represents an unknown error.
  unknown,
}