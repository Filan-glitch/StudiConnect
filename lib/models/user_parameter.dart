import 'package:studiconnect/models/group_parameter.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/models/user.dart';

enum UserSource {
  me,
  groupMember,
  joinGroupRequest,
}

class UserLookupParameters {
  final String userID;
  final UserSource source;
  final GroupLookupParameters? groupLookupParameters;

  UserLookupParameters({
    required this.userID,
    required this.source,
    this.groupLookupParameters,
  });

  User? get user {
    switch (source) {
      case UserSource.me:
        return store.state.user;
      case UserSource.groupMember:
        return groupLookupParameters?.group?.members
            ?.firstWhere((user) => user.id == userID);
      case UserSource.joinGroupRequest:
        return groupLookupParameters?.group?.joinRequests
            ?.firstWhere((user) => user.id == userID);
    }
  }
}
