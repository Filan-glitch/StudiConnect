import 'package:graphql/client.dart';

import 'api.dart';

Future<Map<String, dynamic>?> searchGroups(
  String module,
  int radius,
) async {
  return GraphQL.query(
    QueryOptions(
      document: gql("""
      query SearchGroups(\$module: String!, \$radius: Int!) {
        searchGroups(module: \$module, radius: \$radius) {
          id
          title
          description
          module
          createdAt
          creator {
            id
            username
          }
          members {
            id
            username
          }
          lat
          lon
        }
      }
"""),
      variables: <String, dynamic>{
        'module': module,
        'radius': radius,
      },
    ),
  );
}
