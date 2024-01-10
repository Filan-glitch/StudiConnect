import 'package:graphql/client.dart';

import 'package:studiconnect/services/graphql/api.dart';

Future<Map<String, dynamic>?> searchGroups(
  String module,
  int radius,
) async {
  return query(
    QueryOptions(
      document: gql('''
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
            email
            university
            major
            bio
            mobile
            discord
          }
          members {
            id
            username
            email
            university
            major
            bio
            mobile
            discord
          }
          lat
          lon
        }
      }
'''),
      variables: <String, dynamic>{
        'module': module,
        'radius': radius,
      },
    ),
  );
}
