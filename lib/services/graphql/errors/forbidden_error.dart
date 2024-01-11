/// This library contains the [ForbiddenException] class.
///
/// {@category EXCEPTIONS}
library services.error.forbidden_error;

import 'package:studiconnect/services/graphql/errors/api_exception.dart';

/// Represents a forbidden exception.
///
/// This class extends the [ApiException] class and provides a custom
/// exception type for handling forbidden errors. It includes a default error
/// message and a default error code.
///
/// The [message] parameter is optional and defaults to a forbidden error message.
/// It represents the error message associated with the exception.
///
/// The [code] parameter is optional and defaults to 403. It represents the error code associated
/// with the exception.
class ForbiddenException extends ApiException {
  ForbiddenException({
    super.message = defaultMessage,
    super.code = 403,
  });

  /// The default error message to be used if no custom message is provided.
  /// It indicates that the user does not have permission for the action.
  static const String defaultMessage =
      'Sie haben keine Berechtigung für diese Aktion.';
}
