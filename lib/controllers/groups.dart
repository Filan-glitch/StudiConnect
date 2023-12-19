import 'package:oktoast/oktoast.dart';

import '../models/group.dart';
import '../models/redux/actions.dart';
import '../models/redux/store.dart';
import '../models/user.dart';
import '../services/graphql/search.dart' as search_service;
import '../services/graphql/group.dart' as service;
import 'api.dart';

Future<void> searchGroups(String module, int radius) async {
  List<Group>? result = await runApiService(
    apiCall: () => search_service.searchGroups(module, radius),
    parser: (result) => (result['searchGroups'] as List<dynamic>)
        .map((group) => Group.fromApi(group))
        .toList(),
  );

  if (result == null) {
    return;
  }

  store.dispatch(Action(ActionTypes.updateSearchResults, payload: result));
}

Future<String> createGroup(String title, String description, String module,
    double lat, double lon) async {
  String? id = await runApiService(
    apiCall: () => service.createGroup(title, description, module, lat, lon),
    parser: (result) => result['createGroup']['id'] as String,
  );

  return id ?? "";
}

Future<void> updateGroup(String id, String title, String description,
    String module, double lat, double lon) async {
  await runApiService(
    apiCall: () =>
        service.updateGroup(id, title, description, module, lat, lon),
    parser: (result) => null,
  );
}

Future<void> deleteGroup(String id) async {
  await runApiService(
    apiCall: () => service.deleteGroup(id),
    parser: (result) => null,
  );
}

Future<void> joinGroup(String id) async {
  await runApiService(
    apiCall: () => service.joinGroup(id),
    parser: (result) => null,
  );

  showToast("Anfrage wurde gesendet");
}

Future<void> leaveGroup(String id) async {
  await runApiService(
    apiCall: () => service.removeMember(id, store.state.user?.username ?? ''),
    parser: (result) => null,
  );

  // update groups of user
  User currentUser = store.state.user!;
  currentUser.groups!.removeWhere((group) => group.id == id);

  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));
}

Future<void> addMember(String id, String username) async {
  await runApiService(
    apiCall: () => service.addMember(id, username),
    parser: (result) => null,
  );

  Group? group = await runApiService(
    apiCall: () => service.loadGroupInfo(id),
    parser: (result) => Group.fromApi(result['group']),
  );

  if (group == null) {
    return;
  }

  // update groups of user
  User currentUser = store.state.user!;
  currentUser.groups!.map((e) => e.id == id ? group : e).toList();
  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));
}

Future<void> removeMember(String id, String username) async {
  await runApiService(
    apiCall: () => service.removeMember(id, username),
    parser: (result) => null,
  );

  Group? group = await runApiService(
    apiCall: () => service.loadGroupInfo(id),
    parser: (result) => Group.fromApi(result['group']),
  );

  if (group == null) {
    return;
  }

  // update groups of user
  User currentUser = store.state.user!;
  currentUser.groups!.map((e) => e.id == id ? group : e).toList();
  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));
}
