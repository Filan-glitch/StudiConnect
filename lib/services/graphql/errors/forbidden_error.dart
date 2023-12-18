import 'package:studiconnect/services/graphql/errors/api_exception.dart';

class ForbiddenException extends ApiException {
  ForbiddenException({
    super.message = defaultMessage,
    super.code = 403,
  });

  static const String defaultMessage =
      "Sie haben keine Berechtigung für diese Aktion.";
}
