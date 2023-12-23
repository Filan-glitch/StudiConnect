import 'package:studiconnect/services/graphql/errors/api_exception.dart';

class UnauthorizedException extends ApiException {
  UnauthorizedException({
    super.message = defaultMessage,
    super.code = 401,
  });

  static const String defaultMessage = "Bitte melden Sie sich erneut an.";
}
