import 'package:studiconnect/services/graphql/errors/api_exception.dart';

class InputException extends ApiException {
  InputException({
    super.message = defaultMessage,
    super.code = 400,
  });

  static const String defaultMessage = "Die Eingabe ist ungültig.";
}
