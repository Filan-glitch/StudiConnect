import 'package:graphql/client.dart';

import 'package:studiconnect/services/graphql/api.dart';

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
            imageExists
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

Future<Map<String, dynamic>?> deleteAccount() {
  return GraphQL.mutate(
    MutationOptions(
      document: gql("""
      mutation DeleteAccount {
        deleteAccount
      }
"""),
    ),
  );
}
