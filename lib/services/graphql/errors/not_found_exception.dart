/// This library contains the [NotFoundException] class.
///
/// {@category EXCEPTIONS}
library services.error.not_found_exception;

import 'package:studiconnect/services/graphql/errors/api_exception.dart';

/// Represents a not found exception.
///
/// This class extends the [ApiException] class and provides a custom
/// exception type for handling not found errors. It includes a default error
/// message and a default error code.
class NotFoundException extends ApiException {

  /// The default constructor.
  NotFoundException({
    super.message = defaultMessage,
    super.code = 404,
  });

  /// The default error message to be used if no custom message is provided.
  /// It indicates that the requested resource was not found.
  static const String defaultMessage =
      'Die angeforderte Ressource wurde nicht gefunden.';
}
