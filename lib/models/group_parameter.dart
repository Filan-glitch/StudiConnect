import 'package:studiconnect/models/group.dart';
import 'package:studiconnect/models/redux/store.dart';

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

  Group? get group {
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
