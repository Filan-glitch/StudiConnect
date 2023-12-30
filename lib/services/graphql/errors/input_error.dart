/// This library contains the [InputException] class.
///
/// {@category EXCEPTIONS}
library services.graphql.errors.input_error;
import 'package:studiconnect/services/graphql/errors/api_exception.dart';

/// Represents an input exception.
///
/// This class extends the [ApiException] class and provides a custom
/// exception type for handling input errors. It includes a default error
/// message and a default error code.
///
/// The [message] parameter is optional and defaults to an input error message.
/// It represents the error message associated with the exception.
///
/// The [code] parameter is optional and defaults to 400. It represents the error code associated
/// with the exception.
class InputException extends ApiException {
  InputException({
    super.message = defaultMessage,
    super.code = 400,
  });

  /// The default error message to be used if no custom message is provided.
  /// It indicates that the input is invalid.
  static const String defaultMessage = "Die Eingabe ist ungültig.";
}