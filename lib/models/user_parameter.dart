/// This library contains the UserLookupParameters model.
///
/// {@category MODELS}
library models.user_parameter;

import 'package:flutter_redux/flutter_redux.dart';
import 'package:studiconnect/models/group_parameter.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:studiconnect/models/user.dart';

/// Enum for different sources of user.
enum UserSource {
  /// The user is the current user.
  me,

  /// The user is a member of a group.
  groupMember,

  /// The user is a join request for a group.
  joinGroupRequest,
}

/// Represents parameters for looking up a user.
///
/// This class is used to define parameters for looking up a user with a userID, source, and groupLookupParameters.
class UserLookupParameters {

  /// The userID of the user to look up.
  final String userID;

  /// The source of the user to look up.
  final UserSource source;

  /// The groupLookupParameters of the user to look up.
  final GroupLookupParameters? groupLookupParameters;

  /// Creates a [UserLookupParameters].
  ///
  /// The [userID] and [source] parameters must not be null.
  UserLookupParameters({
    required this.userID,
    required this.source,
    this.groupLookupParameters,
  });

  /// Gets a user based on the parameters.
  ///
  /// This method does not require any parameters.
  ///
  /// Returns a [User] object.
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