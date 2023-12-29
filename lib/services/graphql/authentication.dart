import 'package:graphql/client.dart';
import 'package:studiconnect/services/graphql/api.dart';

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
