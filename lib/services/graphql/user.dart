/// This library contains all the GraphQL queries and mutations related to the user.
///
/// {@category SERVICES}
library services.graphql.user;
import 'package:graphql/client.dart';
import 'package:studiconnect/services/graphql/api.dart';

/// Fetches the information of a user by their ID.
///
/// The [id] parameter is required and represents the ID of the user.
/// Returns a Future that completes with a Map if the request was successful.
/// The Map contains the user's information.
Future<Map<String, dynamic>?> loadMyUserInfo(String id) async {
  return GraphQL.query(
    QueryOptions(
      document: gql("""
      query LoadMyUserInfo(\$id: ID!) {
        user(id: \$id) {
          id
          email
          username
          email
          university
          major
          lat
          lon
          bio
          mobile
          discord
          groups {
            id
            title
            description
            module
            createdAt
            lat
            lon
            creator {
              id
              username
              university
              major
              bio
              mobile
              discord
            }
            members {
              id
              username
              university
              major
              bio
              mobile
              discord
            }
            joinRequests {
              id
              username
              university
              major
              bio
              mobile
              discord
            }
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

/// Fetches the public information of a user by their ID.
///
/// The [id] parameter is required and represents the ID of the user.
/// Returns a Future that completes with a Map if the request was successful.
/// The Map contains the user's public information.
Future<Map<String, dynamic>?> loadUserInfo(String id) async {
  return GraphQL.query(
    QueryOptions(
      document: gql("""
      query LoadUserInfo(\$id: ID!) {
        user(id: \$id) {
          id
          username
          university
          major
          lat
          lon
          bio
          mobile
          discord
        }
      }
"""),
      variables: <String, dynamic>{
        'id': id,
      },
    ),
  );
}

/// Updates the profile of the current user.
///
/// The [username], [university], [major], [lat], [lon], [bio], [mobile], and [discord] parameters are required.
/// Returns a Future that completes with a Map if the request was successful.
/// The Map contains the ID of the updated user.
Future<Map<String, dynamic>?> updateProfile(
  String username,
  String university,
  String major,
  double lat,
  double lon,
  String bio,
  String mobile,
  String discord,
) {
  return GraphQL.mutate(
    MutationOptions(
      document: gql("""
      mutation UpdateProfile(\$username: String!, \$university: String!, \$major: String!, \$lat: Float!, \$lon: Float!, \$bio: String!, \$mobile: String!, \$discord: String!) {
        updateProfile(
          username: \$username,
          university: \$university,
          major: \$major,
          lat: \$lat,
          lon: \$lon,
          bio: \$bio,
          mobile: \$mobile,
          discord: \$discord,
        ) {
          id
        }
      }
"""),
      variables: <String, dynamic>{
        'username': username,
        'university': university,
        'major': major,
        'lat': lat,
        'lon': lon,
        'bio': bio,
        'mobile': mobile,
        'discord': discord,
      },
    ),
  );
}

/// Deletes the account of the current user.
///
/// Returns a Future that completes with a Map if the request was successful.
/// The Map is empty.
Future<Map<String, dynamic>?> deleteAccount() {
  return GraphQL.mutate(
    MutationOptions(
      document: gql("""
      mutation {
        deleteAccount
      }
"""),
    ),
  );
}