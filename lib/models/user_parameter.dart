import 'package:flutter_redux/flutter_redux.dart';
import 'package:studiconnect/models/group_parameter.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
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

  User? getUser(BuildContext context) {
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    switch (source) {
      case UserSource.me:
        return store.state.user;
      case UserSource.groupMember:
        return groupLookupParameters?.getGroup(context)?.members
            ?.firstWhere((user) => user.id == userID);
      case UserSource.joinGroupRequest:
        return groupLookupParameters?.getGroup(context)?.joinRequests
            ?.firstWhere((user) => user.id == userID);
    }
  }
}
