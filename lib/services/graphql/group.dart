/// This library contains all the GraphQL queries and mutations for the group entity.
///
/// {@category SERVICES}
library services.graphql.group;
import 'package:graphql/client.dart';
import 'package:studiconnect/services/graphql/api.dart';

/// Fetches the information of a group by its ID.
///
/// The [id] parameter is required and represents the ID of the group.
/// Returns a Future that completes with a Map if the request was successful.
/// The Map contains the group's information.
Future<Map<String, dynamic>?> loadGroupInfo(String id) async {
  return query(
    QueryOptions(
      document: gql('''
      query LoadGroupInfo(\$id: ID!) {
        group(id: \$id) {
          id
          title
          description
          module
          createdAt
          lat
          lon
          imageExists
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
          joinRequests {
            id
            username
            email
            university
            major
            bio
            mobile
            discord
          }
        }
      }
'''),
      variables: <String, dynamic>{
        'id': id,
      },
    ),
  );
}

/// Creates a new group with the provided information.
///
/// The [title], [description], [module], [lat], and [lon] parameters are required.
/// Returns a Future that completes with a Map if the request was successful.
/// The Map contains the ID of the newly created group.
Future<Map<String, dynamic>?> createGroup(
  String title,
  String description,
  String module,
  double lat,
  double lon,
) async {
  return mutate(
    MutationOptions(
      document: gql('''
      mutation CreateGroup(\$title: String!, \$description: String!, \$module: String!, \$lat: Float!, \$lon: Float!) {
        createGroup(title: \$title, description: \$description, module: \$module, lat: \$lat, lon: \$lon) {
          id
        }
      }
'''),
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

/// Updates the information of a group by its ID.
///
/// The [id], [title], [description], [module], [lat], and [lon] parameters are required.
/// Returns a Future that completes with a Map if the request was successful.
/// The Map contains the ID of the updated group.
Future<Map<String, dynamic>?> updateGroup(
  String id,
  String title,
  String description,
  String module,
  double lat,
  double lon,
) async {
  return mutate(
    MutationOptions(
      document: gql('''
      mutation UpdateGroup(\$id: ID!, \$title: String!, \$description: String!, \$module: String!, \$lat: Float!, \$lon: Float!) {
        updateGroup(id: \$id, title: \$title, description: \$description, module: \$module, lat: \$lat, lon: \$lon) {
          id
        }
      }
'''),
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

/// Deletes a group by its ID.
///
/// The [id] parameter is required and represents the ID of the group.
/// Returns a Future that completes with a Map if the request was successful.
/// The Map is empty.
Future<Map<String, dynamic>?> deleteGroup(
  String id,
) async {
  return mutate(
    MutationOptions(
      document: gql('''
      mutation DeleteGroup(\$id: ID!) {
        deleteGroup(id: \$id)
      }
'''),
      variables: <String, dynamic>{
        'id': id,
      },
    ),
  );
}

/// Sends a join group request for a group by its ID.
///
/// The [id] parameter is required and represents the ID of the group.
/// Returns a Future that completes with a Map if the request was successful.
/// The Map is empty.
Future<Map<String, dynamic>?> joinGroup(
  String id,
) async {
  return mutate(
    MutationOptions(
      document: gql('''
      mutation JoinGroup(\$id: ID!) {
        joinGroup(id: \$id)
      }
'''),
      variables: <String, dynamic>{
        'id': id,
      },
    ),
  );
}

/// Adds a member to a group.
///
/// The [id] and [user] parameters are required and represent the ID of the group and the user.
/// Returns a Future that completes with a Map if the request was successful.
/// The Map is empty.
Future<Map<String, dynamic>?> addMember(String id, String user) async {
  return mutate(
    MutationOptions(
      document: gql('''
      mutation AddMember(\$id: ID!, \$user: ID!) {
        addMember(id: \$id, user: \$user)
      }
'''),
      variables: <String, dynamic>{
        'id': id,
        'user': user,
      },
    ),
  );
}

/// Removes a member from a group.
///
/// The [id] and [user] parameters are required and represent the ID of the group and the user.
/// Returns a Future that completes with a Map if the request was successful.
/// The Map is empty.
Future<Map<String, dynamic>?> removeMember(String id, String user) async {
  return mutate(
    MutationOptions(
      document: gql('''
      mutation RemoveMember(\$id: ID!, \$user: ID!) {
        removeMember(id: \$id, user: \$user)
      }
'''),
      variables: <String, dynamic>{
        'id': id,
        'user': user,
      },
    ),
  );
}

/// Removes a join request from a group.
///
/// The [groupID] and [userID] parameters are required and represent the ID of the group and the user.
/// Returns a Future that completes with a Map if the request was successful.
/// The Map is empty.
Future<Map<String, dynamic>?> removeJoinRequest(
    String groupID, String userID) async {
  return mutate(
    MutationOptions(
      document: gql('''
      mutation RemoveJoinRequest(\$groupID: ID!, \$userID: ID!) {
        removeJoinRequest(id: \$groupID, user: \$userID)
      }
'''),
      variables: <String, dynamic>{
        'groupID': groupID,
        'userID': userID,
      },
    ),
  );
}