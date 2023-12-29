import 'package:oktoast/oktoast.dart';

import 'package:studiconnect/models/group.dart';
import 'package:studiconnect/models/redux/actions.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/models/user.dart';
import 'package:studiconnect/services/graphql/search.dart' as search_service;
import 'package:studiconnect/services/graphql/group.dart' as service;
import 'package:studiconnect/controllers/api.dart';

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

Future<void> createGroup(String title, String description, String module,
    double lat, double lon) async {
  String? id = await runApiService(
    apiCall: () => service.createGroup(title, description, module, lat, lon),
    parser: (result) => result['createGroup']['id'],
  );

  if (id == null) {
    return;
  }

  Group? group = await runApiService(
    apiCall: () => service.loadGroupInfo(id),
    parser: (result) => Group.fromApi(result['group']),
  );

  if (group == null) {
    return;
  }

  // update groups of user
  User currentUser = store.state.user!;
  currentUser.groups!.add(group);
  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));
}

Future<void> updateGroup(String id, String title, String description,
    String module, double lat, double lon) async {
  await runApiService(
    apiCall: () =>
        service.updateGroup(id, title, description, module, lat, lon),
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
  currentUser.groups =
      currentUser.groups!.map((e) => e.id == id ? group : e).toList();
  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));
}

Future<void> deleteGroup(String id) async {
  await runApiService(
    apiCall: () => service.deleteGroup(id),
    parser: (result) => null,
  );

  // update groups of user
  User currentUser = store.state.user!;
  currentUser.groups!.removeWhere((group) => group.id == id);
  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));
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
    apiCall: () => service.removeMember(id, store.state.user?.id ?? ''),
    parser: (result) => null,
  );

  // update groups of user
  User currentUser = store.state.user!;
  currentUser.groups!.removeWhere((group) => group.id == id);

  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));
}

Future<void> addMember(String id, String userID) async {
  await runApiService(
    apiCall: () => service.addMember(id, userID),
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
  currentUser.groups =
      currentUser.groups!.map((e) => e.id == id ? group : e).toList();
  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));
}

Future<void> removeMember(String id, String userID) async {
  await runApiService(
    apiCall: () => service.removeMember(id, userID),
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
  currentUser.groups =
      currentUser.groups!.map((e) => e.id == id ? group : e).toList();
  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));
}

Future<void> removeJoinRequest(String groupID, String userID) async {
  await runApiService(
    apiCall: () => service.removeJoinRequest(groupID, userID),
    parser: (result) => null,
  );

  Group? group = await runApiService(
    apiCall: () => service.loadGroupInfo(groupID),
    parser: (result) => Group.fromApi(result['group']),
  );

  if (group == null) {
    return;
  }

  // update groups of user
  User currentUser = store.state.user!;
  currentUser.groups =
      currentUser.groups!.map((e) => e.id == groupID ? group : e).toList();
  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));
}
