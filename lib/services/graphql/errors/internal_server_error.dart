import 'package:studiconnect/services/graphql/errors/api_exception.dart';

class InternalServerException extends ApiException {
  InternalServerException({
    super.message = defaultMessage,
    super.code = 500,
  });

  static const String defaultMessage =
      "Auf dem Server ist ein Fehler aufgetreten.";
}
