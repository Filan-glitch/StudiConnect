/// This library contains the GraphQL queries and mutations for the authentication
///
/// {@category SERVICES}
library services.graphql.authentication;
import 'package:graphql/client.dart';
import 'package:studiconnect/services/graphql/api.dart';

/// Logs in a user with an ID token.
///
/// The [idToken] parameter is required and represents the ID token of the user.
/// Returns a Future that completes with a Map if the login was successful.
/// The Map contains the session ID and the user data.
Future<Map<String, dynamic>?> login(String idToken) async {
  return GraphQL.mutate(
    MutationOptions(
      document: gql("""
      mutation Login(\$token: String!) {
        login(token: \$token) {
          sessionID
          user
        }
      }
"""),
      variables: <String, dynamic>{
        'token': idToken,
      },
    ),
  );
}

/// Logs out the current user.
///
/// Returns a Future that completes with a Map if the logout was successful.
/// The Map is empty.
Future<Map<String, dynamic>?> logout() async {
  return GraphQL.mutate(
    MutationOptions(
      document: gql("""
      mutation Logout {
        logout
      }
"""),
    ),
  );
}