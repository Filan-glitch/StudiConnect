import 'package:graphql/client.dart';
import 'package:studiconnect/services/graphql/api.dart';

Future<Map<String, dynamic>?> getMessages(String groupID) async {
  return GraphQL.query(
    QueryOptions(
      document: gql("""
      query GetMessages(\$groupID: ID!) {
        messages(group: \$groupID) {
          id
          content
          sender {
            id
            username
          }
          sendAt
        }
      }
"""),
      variables: <String, dynamic>{
        'groupID': groupID,
      },
    ),
  );
}

Future<Map<String, dynamic>?> sendMessage(
  String groupID,
  String content,
) async {
  return GraphQL.mutate(
    MutationOptions(
      document: gql("""
      mutation SendMessage(\$groupID: ID!, \$content: String!) {
        sendMessage(group: \$groupID, content: \$content) {
          id
        }
      }
"""),
      variables: <String, dynamic>{
        'groupID': groupID,
        'content': content,
      },
    ),
  );
}
