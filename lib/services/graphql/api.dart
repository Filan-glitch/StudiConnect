import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';

import '../../constants.dart';
import '/models/redux/store.dart';
import 'errors/api_exception.dart';
import 'errors/input_error.dart';
import 'errors/internal_server_error.dart';
import 'errors/not_found_exception.dart';
import 'errors/connection_error.dart';
import 'errors/forbidden_error.dart';
import 'errors/unauthorized_error.dart';

/// Implementations for GraphQL API queries & mutations.
class GraphQL {
  /// Builds a new [GraphQLClient], based on the session id and the settings about the server.
  static Future<GraphQLClient> _getClient() async {
    final httpLink = HttpLink(
      '$backendURL/api/graphql',
      defaultHeaders: {
        "Cookies": "session: ${store.state.sessionID}",
      },
    );

    return GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );
  }

  /// Performs the GraphQL query, specified in [options].
  ///
  /// If the query was successful and the client received data, it will be returned as a [Map],
  /// otherwise null will be returned.
  /// If an error occurred during the request, a [HttpException] for a unknown error will be thrown.
  /// If the result from the server indicates with a HTTP status code, that an
  /// error occurred, a [HttpException] with the code-specific error message will be thrown.
  ///
  /// See also:
  /// - [_getClient] which builds the client object.
  /// - [_getExceptionFromResult] which parses an error-response into a HttpException.
  static Future<Map<String, dynamic>?> query(QueryOptions options) async {
    QueryResult result;

    try {
      result = await (await _getClient()).query(options);
    } catch (e) {
      if (kDebugMode) log(e.toString());

      throw ApiException();
    }

    if (result.hasException) {
      throw _getExceptionFromResult(result);
    }

    return result.data;
  }

  /// Performs the GraphQL mutation, specified in [options].
  ///
  /// If the mutation was successful and the client received data, it will be returned as a [Map],
  /// otherwise null will be returned.
  /// If an error occurred during the request, a [HttpException] for a unknown error will be thrown.
  /// If the result from the server indicates with a HTTP status code, that an
  /// error occurred, a [HttpException] with the code-specific error message will be thrown.
  ///
  /// See also:
  /// - [_getClient] which builds the client object.
  /// - [_getExceptionFromResult] which parses an error-response into a HttpException.
  static Future<Map<String, dynamic>?> mutate(MutationOptions options) async {
    QueryResult result;
    try {
      result = await (await _getClient()).mutate(options);
    } catch (e) {
      if (kDebugMode) log(e.toString());

      throw ApiException();
    }

    if (result.hasException) {
      throw _getExceptionFromResult(result);
    }

    return result.data;
  }

  static ApiException _getExceptionFromResult(QueryResult result) {
    LinkException? exception = result.exception!.linkException;

    int statusCode = 0;
    String? customMessage;

    // extract the statusCode and the message, if specified.
    if (exception is HttpLinkServerException) {
      statusCode = exception.response.statusCode;

      if ((exception.parsedResponse?.errors?.length ?? 0) > 0) {
        customMessage = exception.parsedResponse?.errors?[0].message;
      }
    }

    if (kDebugMode) log(customMessage ?? "no msg");

    if (statusCode < 100) {
      throw ConnectionException(code: statusCode);
    } else if (statusCode == 401) {
      throw UnauthorizedException(
        code: statusCode,
        message: customMessage ?? UnauthorizedException.defaultMessage,
      );
    } else if (statusCode == 403) {
      throw ForbiddenException(
        code: statusCode,
        message: customMessage ?? ForbiddenException.defaultMessage,
      );
    } else if (statusCode == 404) {
      throw NotFoundException(
        code: statusCode,
        message: customMessage ?? NotFoundException.defaultMessage,
      );
    } else if (statusCode == 502 || statusCode == 504) {
      throw ConnectionException(code: statusCode);
    } else if (statusCode >= 500) {
      throw InternalServerException(
        code: statusCode,
        message: customMessage ?? InternalServerException.defaultMessage,
      );
    } else if (statusCode >= 400) {
      throw InputException(
        code: statusCode,
        message: customMessage ?? InputException.defaultMessage,
      );
    }

    if (exception is NetworkException || exception is ServerException) {
      throw ConnectionException(code: statusCode);
    }

    return ApiException();
  }
}
