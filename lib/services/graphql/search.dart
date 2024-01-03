/// This library contains the functions that are used to search for groups.
///
/// {@category SERVICES}
library services.graphql.search;
import 'package:graphql/client.dart';
import 'package:studiconnect/services/graphql/api.dart';

/// Searches for groups based on a module and a radius.
///
/// The [module] parameter is required and represents the module of the groups.
/// The [radius] parameter is required and represents the radius for the search.
/// Returns a Future that completes with a Map if the request was successful.
/// The Map contains the groups that match the search criteria.
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