import 'package:studiconnect/services/graphql/errors/api_exception.dart';

class NotFoundException extends ApiException {
  NotFoundException({
    super.message = defaultMessage,
    super.code = 404,
  });

  static const String defaultMessage =
      "Die angeforderte Ressource wurde nicht gefunden.";
}
