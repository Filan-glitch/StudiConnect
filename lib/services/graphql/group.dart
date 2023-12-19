import 'package:graphql/client.dart';

import 'api.dart';

Future<Map<String, dynamic>?> loadGroupInfo(String id) async {
  return GraphQL.query(
    QueryOptions(
      document: gql("""
      query LoadGroupInfo(\$id: String!) {
        group(id: \$id) {
          id
          name
          description
          members {
            id
            username
          }
        }
      }
"""),
      variables: <String, dynamic>{
        'id': id,
      },
    ),
  );
}

Future<Map<String, dynamic>?> createGroup(
  String title,
  String description,
  String module,
  double lat,
  double lon,
) async {
  return GraphQL.mutate(
    MutationOptions(
      document: gql("""
      mutation CreateGroup(\$title: String!, \$description: String!, \$module: String!, \$lat: Float!, \$lon: Float!) {
        createGroup(title: \$title, description: \$description, module: \$module, lat: \$lat, lon: \$lon) {
          id
        }
      }
"""),
      variables: <String, dynamic>{
        'title': title,
        'description': description,
        'module': module,
        'lat': lat,
        'lon': lon,
      },
    ),
  );
}

Future<Map<String, dynamic>?> updateGroup(
  String id,
  String title,
  String description,
  String module,
  double lat,
  double lon,
) async {
  return GraphQL.mutate(
    MutationOptions(
      document: gql("""
      mutation UpdateGroup(\$id: String!, \$title: String!, \$description: String!, \$module: String!, \$lat: Float!, \$lon: Float!) {
        updateGroup(id: \$id, title: \$title, description: \$description, module: \$module, lat: \$lat, lon: \$lon) {
          id
        }
      }
"""),
      variables: <String, dynamic>{
        'id': id,
        'title': title,
        'description': description,
        'module': module,
        'lat': lat,
        'lon': lon,
      },
    ),
  );
}

Future<Map<String, dynamic>?> deleteGroup(
  String id,
) async {
  return GraphQL.mutate(
    MutationOptions(
      document: gql("""
      mutation DeleteGroup(\$id: String!) {
        deleteGroup(id: \$id)
      }
"""),
      variables: <String, dynamic>{
        'id': id,
      },
    ),
  );
}

Future<Map<String, dynamic>?> joinGroup(
  String id,
) async {
  return GraphQL.mutate(
    MutationOptions(
      document: gql("""
      mutation JoinGroup(\$id: String!) {
        joinGroup(id: \$id)
      }
"""),
      variables: <String, dynamic>{
        'id': id,
      },
    ),
  );
}

Future<Map<String, dynamic>?> addMember(String id, String user) async {
  return GraphQL.mutate(
    MutationOptions(
      document: gql("""
      mutation AddMember(\$id: String!, \$user: String!) {
        addMember(id: \$id, user: \$user)
      }
"""),
      variables: <String, dynamic>{
        'id': id,
        'user': user,
      },
    ),
  );
}

Future<Map<String, dynamic>?> removeMember(String id, String user) async {
  return GraphQL.mutate(
    MutationOptions(
      document: gql("""
      mutation RemoveMember(\$id: String!, \$user: String!) {
        removeMember(id: \$id, user: \$user)
      }
"""),
      variables: <String, dynamic>{
        'id': id,
        'user': user,
      },
    ),
  );
}
