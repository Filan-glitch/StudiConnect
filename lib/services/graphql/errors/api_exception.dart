class ApiException implements Exception {
  final String message;
  final int? code;

  static const String defaultMessage =
      "Es ist ein unbekannter Fehler aufgetreten.";

  ApiException({
    this.message = defaultMessage,
    this.code,
  });
}
