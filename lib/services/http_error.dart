/// Represents an API exception.
///
/// This class implements the [Exception] interface and provides a custom
/// exception type for handling API errors. It includes a predefined set of
/// exceptions for common error scenarios, each with a default error message.
///
/// The [message] parameter is optional and represents the error message
/// associated with the exception.
class ApiException implements Exception {
  /// Client error, typically due to incorrect data or an outdated app.
  static ApiException clientError =
      const ApiException("Die Daten sind falsch oder die App ist veraltet.");

  /// Server error, indicating a problem on the server side.
  static ApiException serverError =
      const ApiException("Auf dem Server ist ein Fehler aufgetreten.");

  /// Proxy error, indicating that the server is not reachable.
  static ApiException proxyError =
      const ApiException("Der Server ist nicht erreichbar.");

  /// Authorization error, indicating that the user needs to authenticate again.
  static ApiException notAuthorized =
      const ApiException("Bitte melde dich erneut an.");

  /// Not found error, indicating that the requested data could not be found.
  static ApiException notFound =
      const ApiException("Die Daten konnten nicht gefunden werden.");

  /// Forbidden error, indicating that the user does not have permission to view the data.
  static ApiException forbidden =
      const ApiException("Du hast keine Berechtigung, diese Daten einzusehen.");

  /// Deprecated error, indicating that the API interface seems to be outdated.
  static ApiException deprecated =
      const ApiException("Die Schnittstelle scheint veraltet zu sein.");

  /// Connection error, indicating that a connection could not be established.
  static ApiException connectionError =
      const ApiException("Es konnte keine Verbindung hergestellt werden.");

  /// Unknown error, indicating an unknown error scenario.
  static ApiException unknown =
      const ApiException("Es ist ein unbekannter Fehler aufgetreten.");

  /// Creates an [ApiException].
  ///
  /// The [message] parameter represents the error message associated with the exception.
  const ApiException(
    this.message,
  );

  /// The error message associated with the exception.
  final String message;
}

/// Represents an error category.
///
/// This enum provides a set of categories for classifying errors.
enum ErrorCategory {
  /// Client error, typically due to incorrect data or an outdated app.
  client,

  /// Server error, indicating a problem on the server side.
  server,

  /// Connection error, indicating that a connection could not be established.
  connection,

  /// Unknown error, indicating an unknown error scenario.
  unknown,
}