/// This library contains the [GroupLookupParameters] class.
///
/// {@category MODELS}
library models.group_parameter;

import 'package:flutter/material.dart';
import 'package:studiconnect/models/group.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:studiconnect/models/redux/app_state.dart';

/// Enum representing the source of a group.
enum GroupSource {
  /// The group is being retrieved from the user's own groups.
  myGroups,
  /// The group is being retrieved from the search results.
  searchedGroups,
}

/// A class that represents the parameters for looking up a group.
///
/// This class includes the group ID and the source of the group.
/// It also includes a method for getting the group from the Redux store.
class GroupLookupParameters {
  /// The ID of the group.
  final String groupID;

  /// The source of the group.
  final GroupSource source;

  /// Creates a new instance of [GroupLookupParameters].
  ///
  /// The [groupID] and [source] parameters are required.
  GroupLookupParameters({
    required this.groupID,
    required this.source,
  });

  /// Gets the group from the Redux store.
  ///
  /// This method uses the [source] to determine where to get the group from.
  /// If the source is [GroupSource.myGroups], it gets the group from the user's groups.
  /// If the source is [GroupSource.searchedGroups], it gets the group from the search results.
  ///
  /// The [context] parameter is required and represents the build context.
  ///
  /// Returns the group if it is found, or null if it is not found.
  Group? getGroup(BuildContext context) {
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    switch (source) {
      case GroupSource.myGroups:
        return store.state.user?.groups
            ?.firstWhere((group) => group.id == groupID);
      case GroupSource.searchedGroups:
        return store.state.searchResults
            .firstWhere((group) => group.id == groupID);
    }
  }
}