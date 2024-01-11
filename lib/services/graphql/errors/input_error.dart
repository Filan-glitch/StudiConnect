/// This library contains the [InputException] class.
///
/// {@category EXCEPTIONS}
library services.error.input_error;

import 'package:studiconnect/services/graphql/errors/api_exception.dart';

/// Represents an input exception.
///
/// This class extends the [ApiException] class and provides a custom
/// exception type for handling input errors. It includes a default error
/// message and a default error code.
class InputException extends ApiException {

  /// The default constructor.
  InputException({
    super.message = defaultMessage,
    super.code = 400,
  });

  /// The default error message to be used if no custom message is provided.
  /// It indicates that the input is invalid.
  static const String defaultMessage = 'Die Eingabe ist ungültig.';
}
