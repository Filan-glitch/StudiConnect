import 'package:graphql/client.dart';
import 'package:studiconnect/services/graphql/api.dart';

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
