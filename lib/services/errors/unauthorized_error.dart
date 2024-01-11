/// This library contains the [UnauthorizedException] class.
///
/// {@category EXCEPTIONS}
library services.error.unauthorized_error;

import 'package:studiconnect/services/errors/api_exception.dart';

/// Represents an unauthorized exception.
///
/// This class extends the [ApiException] class and provides a custom
/// exception type for handling unauthorized errors. It includes a default error
/// message and a default error code.
///
/// The [message] parameter is optional and defaults to an unauthorized error message.
/// It represents the error message associated with the exception.
///
/// The [code] parameter is optional and defaults to 401. It represents the error code associated
/// with the exception.
class UnauthorizedException extends ApiException {
  UnauthorizedException({
    super.message = defaultMessage,
    super.code = 401,
  });

  /// The default error message to be used if no custom message is provided.
  /// It indicates that the user needs to authenticate again.
  static const String defaultMessage = 'Bitte melden Sie sich erneut an.';
}
