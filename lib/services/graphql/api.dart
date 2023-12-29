import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';

import 'package:studiconnect/constants.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/services/graphql/errors/api_exception.dart';
import 'package:studiconnect/services/graphql/errors/connection_error.dart';
import 'package:studiconnect/services/rest/api.dart';

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

    processHttpStatusCodes(statusCode, customMessage: customMessage);

    if (exception is NetworkException || exception is ServerException) {
      throw ConnectionException(code: statusCode);
    }

    return ApiException();
  }
}
