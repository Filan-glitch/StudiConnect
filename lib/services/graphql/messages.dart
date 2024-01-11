/// This library contains the GraphQL services for messages.
///
/// {@category SERVICES}
library services.graphql.messages;

import 'package:graphql/client.dart';
import 'package:studiconnect/services/graphql/api.dart';

/// Fetches messages for a specific group.
///
/// This function sends a GraphQL query to fetch messages for a specific group.
///
/// Returns a [Future] that completes with a map containing the response data.
Future<Map<String, dynamic>?> getMessages(String groupID, int page) async {
  return query(
    QueryOptions(
      document: gql('''
      query GetMessages(\$groupID: ID!, \$page: Int!) {
        messages(group: \$groupID, page: \$page) {
          id
          content
          sender {
            id
            username
          }
          sendAt
        }
      }
'''),
      variables: <String, dynamic>{
        'groupID': groupID,
        'page': page,
      },
    ),
  );
}

/// Sends a message to a specific group.
///
/// This function sends a GraphQL mutation to send a message to a specific group.
///
/// Returns a [Future] that completes with a map containing the response data.
Future<Map<String, dynamic>?> sendMessage(
  String groupID,
  String content,
) async {
  return mutate(
    MutationOptions(
      document: gql('''
      mutation SendMessage(\$groupID: ID!, \$content: String!) {
        sendMessage(group: \$groupID, content: \$content) {
          id
        }
      }
'''),
      variables: <String, dynamic>{
        'groupID': groupID,
        'content': content,
      },
    ),
  );
}