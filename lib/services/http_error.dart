enum HTTPException implements Exception {
  clientError(message: "Die Daten sind falsch oder die App ist veraltet."),
  serverError(message: "Auf dem Server ist ein Fehler aufgetreten."),
  proxyError(message: "Der Server ist nicht erreichbar."),
  notAuthorized(message: "Bitte melde dich erneut an."),
  notFound(message: "Die Daten konnten nicht gefunden werden."),
  forbidden(message: "Du hast keine Berechtigung, diese Daten einzusehen."),
  deprecated(message: "Die Schnittstelle scheint veraltet zu sein."),
  connectionError(message: "Es konnte keine Verbindung hergestellt werden."),
  unknown(message: "Es ist ein unbekannter Fehler aufgetreten.");

  const HTTPException({
    required this.message,
  });

  final String message;
}

