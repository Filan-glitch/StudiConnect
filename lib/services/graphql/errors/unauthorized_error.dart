/// This library contains the [UnauthorizedException] class.
///
/// {@category EXCEPTIONS}
library services.error.unauthorized_error;

import 'package:studiconnect/services/graphql/errors/api_exception.dart';

/// Represents an unauthorized exception.
///
/// This class extends the [ApiException] class and provides a custom
/// exception type for handling unauthorized errors. It includes a default error
/// message and a default error code.
class UnauthorizedException extends ApiException {

  /// The default constructor.
  UnauthorizedException({
    super.message = defaultMessage,
    super.code = 401,
  });

  /// The default error message to be used if no custom message is provided.
  /// It indicates that the user needs to authenticate again.
  static const String defaultMessage = 'Bitte melden Sie sich erneut an.';
}
