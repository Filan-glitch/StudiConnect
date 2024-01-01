/// This library contains the graphql api services for the application.
///
/// {@category SERVICES}
library services.graphql.api;

import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:studiconnect/constants.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/services/errors/api_exception.dart';
import 'package:studiconnect/services/errors/connection_error.dart';
import 'package:studiconnect/services/rest/api.dart';

/// This class provides methods for performing GraphQL queries and mutations.
class GraphQL {
  /// Builds a new [GraphQLClient], based on the session id and the settings about the server.
  /// Returns a [GraphQLClient] instance.
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

  /// Performs a GraphQL query.
  ///
  /// [options] - The options for the query.
  /// Returns a [Map] if the query was successful, otherwise null.
  /// Throws an [ApiException] if an error occurred during the request.
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

  /// Performs a GraphQL mutation.
  ///
  /// [options] - The options for the mutation.
  /// Returns a [Map] if the mutation was successful, otherwise null.
  /// Throws an [ApiException] if an error occurred during the request.
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

  /// Parses an error-response into a [ApiException].
  ///
  /// [result] - The result from the server.
  /// Returns an [ApiException].
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
