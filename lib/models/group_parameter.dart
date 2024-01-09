import 'package:flutter/material.dart';
import 'package:studiconnect/models/group.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:studiconnect/models/redux/app_state.dart';

enum GroupSource {
  myGroups,
  searchedGroups,
}

class GroupLookupParameters {
  final String groupID;
  final GroupSource source;

  GroupLookupParameters({
    required this.groupID,
    required this.source,
  });

  Group? getGroup(BuildContext context) {
  Store<AppState> store = StoreProvider.of<AppState>(context);
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
