/// This library contains functions for groups.
///
/// {@category CONTROLLERS}
library controllers.groups;

import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:studiconnect/models/group.dart';
import 'package:studiconnect/models/redux/actions.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/models/user.dart';
import 'package:studiconnect/services/graphql/search.dart' as search_service;
import 'package:studiconnect/services/graphql/group.dart' as service;
import 'package:studiconnect/services/rest/group_image.dart' as restService;
import 'package:studiconnect/controllers/api.dart';

/// Searches for groups based on the provided module and radius.
///
/// The [module] parameter is required and represents the module to search for.
///
/// The [radius] parameter is required and represents the radius of the search.
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

/// Creates a new group with the provided title, description, module, latitude, and longitude.
///
/// The [title], [description], [module], [lat], and [lon] parameters are required and represent the corresponding properties of the new group.
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

/// Updates the group with the provided ID, title, description, module, latitude, and longitude.
///
/// The [id], [title], [description], [module], [lat], and [lon] parameters are required and represent the new values of the corresponding properties of the group.
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

/// Deletes the group with the provided ID.
///
/// The [id] parameter is required and represents the ID of the group to be deleted.
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

/// Sends a request to join the group with the provided ID.
///
/// The [id] parameter is required and represents the ID of the group to join.
Future<void> joinGroup(String id) async {
  await runApiService(
    apiCall: () => service.joinGroup(id),
    parser: (result) => null,
  );

  showToast("Anfrage wurde gesendet");
}

/// Leaves the group with the provided ID.
///
/// The [id] parameter is required and represents the ID of the group to leave.
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

/// Adds a member to the group with the provided ID.
///
/// The [id] and [userID] parameters are required and represent the ID of the group and the ID of the user to add, respectively.
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

/// Removes a member from the group with the provided ID.
///
/// The [id] and [userID] parameters are required and represent the ID of the group and the ID of the user to remove, respectively.
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

/// Removes a join request from the group with the provided ID.
///
/// The [groupID] and [userID] parameters are required and represent the ID of the group and the ID of the user whose join request is to be removed, respectively.
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

Future<void> uploadGroupImage(String id, XFile file) async {
  Uint8List content = await file.readAsBytes();

  await runRestApi(
    apiCall: () => restService.uploadGroupImage(id, content),
    parser: (result) => null,
  );

  // update groups of user
  User currentUser = store.state.user!;
  currentUser.groups = currentUser.groups!.map((e) {
    if (e.id == id) {
      return e.update(imageExists: true);
    }
    return e;
  }).toList();

  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));

  showToast("Profilbild erfolgreich hochgeladen.");
}

Future<void> deleteGroupImage(String id) async {
  await runRestApi(
      apiCall: () => restService.deleteGroupImage(id),
      parser: (result) => null);

  store.dispatch(
    Action(
      ActionTypes.setProfileImageAvailable,
      payload: false,
    ),
  );

  // update groups of user
  User currentUser = store.state.user!;
  currentUser.groups = currentUser.groups!.map((e) {
    if (e.id == id) {
      return e.update(imageExists: false);
    }
    return e;
  }).toList();

  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));

  showToast(
      "Profilbild erfolgreich gelöscht. Evtl. liegt das Bild noch im Cache.");
}
