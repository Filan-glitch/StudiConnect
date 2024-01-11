class ApiException implements Exception {
  static ApiException clientError =
      const ApiException('Die Daten sind falsch oder die App ist veraltet.');
  static ApiException serverError =
      const ApiException('Auf dem Server ist ein Fehler aufgetreten.');
  static ApiException proxyError =
      const ApiException('Der Server ist nicht erreichbar.');
  static ApiException notAuthorized =
      const ApiException('Bitte melde dich erneut an.');
  static ApiException notFound =
      const ApiException('Die Daten konnten nicht gefunden werden.');
  static ApiException forbidden =
      const ApiException('Du hast keine Berechtigung, diese Daten einzusehen.');
  static ApiException deprecated =
      const ApiException('Die Schnittstelle scheint veraltet zu sein.');
  static ApiException connectionError =
      const ApiException('Es konnte keine Verbindung hergestellt werden.');
  static ApiException unknown =
      const ApiException('Es ist ein unbekannter Fehler aufgetreten.');

  const ApiException(
    this.message,
  );

  final String message;
}

enum ErrorCategory {
  client,
  server,
  connection,
  unknown,
}
