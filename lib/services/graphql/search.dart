/// This library contains the function that is used to search for groups based on a module and a radius.
///
/// {@category SERVICES}
library services.graphql.search;
import 'package:graphql/client.dart';
import 'package:studiconnect/services/graphql/api.dart';

/// Searches for groups based on a module and a radius.
///
/// The [module] parameter is required and represents the module of the groups.
/// The [radius] parameter is required and represents the radius for the search in kilometers.
/// This function sends a GraphQL query to the server with the module and radius as variables.
/// The server responds with a list of groups that match the search criteria.
/// Each group in the list includes the group's ID, title, description, module, creation date, creator's ID and username, members' ID and username, and the latitude and longitude of the group's location.
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