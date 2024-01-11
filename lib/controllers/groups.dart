/// This library contains functions for groups.
///
/// {@category CONTROLLERS}
library controllers.groups;

import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:studiconnect/models/group.dart';
import 'package:studiconnect/models/redux/actions.dart';
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/models/user.dart';
import 'package:studiconnect/services/graphql/search.dart' as search_service;
import 'package:studiconnect/services/graphql/group.dart' as service;
import 'package:studiconnect/services/logger_provider.dart';
import 'package:studiconnect/services/rest/group_image.dart' as rest_service;
import 'package:studiconnect/controllers/api.dart';
import 'package:studiconnect/constants.dart';

import '../services/graphql/errors/api_exception.dart';

/// Searches for groups based on the provided module and radius.
///
/// The [module] parameter is required and represents the module to search for.
///
/// The [radius] parameter is required and represents the radius of the search.
Future<void> searchGroups(String module, int radius) async {
  final List<Group>? result = await runApiService(
    apiCall: () => search_service.searchGroups(module, radius),
    parser: (result) => (result['searchGroups'] as List<dynamic>)
        .map((group) => Group.fromApi(group))
        .toList(),
  );

  if (result == null) {
    log('searchGroups: result was null');
    return;
  }

  store.dispatch(Action(ActionTypes.updateSearchResults, payload: result));
}

/// Creates a new group with the provided title, description, module, latitude, and longitude.
///
/// The [title], [description], [module], [lat], and [lon] parameters are required and represent the corresponding properties of the new group.
Future<bool> createGroup(String title, String description, String module,
    double lat, double lon) async {
  final String? id = await runApiService(
    apiCall: () => service.createGroup(title, description, module, lat, lon),
    parser: (result) => result['createGroup']['id'],
  );

  if (id == null) {
    log('createGroup: id was null');
    return false;
  }

  final Group? group = await runApiService(
    apiCall: () => service.loadGroupInfo(id),
    parser: (result) => Group.fromApi(result['group']),
  );

  if (group == null) {
    log('createGroup: group was null');
    return false;
  }

  // update groups of user
  final User currentUser = store.state.user!;
  currentUser.groups!.add(group);
  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));

  return true;
}

/// Updates the group with the provided ID, title, description, module, latitude, and longitude.
///
/// The [id], [title], [description], [module], [lat], and [lon] parameters are required and represent the new values of the corresponding properties of the group.
Future<bool> updateGroup(String id, String title, String description,
    String module, double lat, double lon) async {
  try {
    await runApiService(
      apiCall: () =>
          service.updateGroup(id, title, description, module, lat, lon),
      shouldRethrow: true,
    );
  } on ApiException catch (e) {
    showToast(e.message);
    return false;
  } catch (e) {
    showToast('Die Gruppe konnte nicht aktualisiert werden.');
    return false;
  }

  final Group? group = await runApiService(
    apiCall: () => service.loadGroupInfo(id),
    parser: (result) => Group.fromApi(result['group']),
  );

  if (group == null) {
    showToast('Die Gruppeninformationen konnte nicht geladen werden.');
    return false;
  }

  // update groups of user
  final User currentUser = store.state.user!;
  currentUser.groups = currentUser.groups!
      .map((e) => e.id == id ? group.update(messages: e.messages) : e)
      .toList();
  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));

  return true;
}

/// Deletes the group with the provided ID.
///
/// The [id] parameter is required and represents the ID of the group to be deleted.
Future<bool> deleteGroup(String id) async {
  try {
    await runApiService(
      apiCall: () => service.deleteGroup(id),
      shouldRethrow: true,
    );
  } on ApiException catch (e) {
    showToast(e.message);
    return false;
  } catch (e) {
    showToast('Die Gruppe konnte nicht gelöscht werden.');
    return false;
  }

  // update groups of user
  final User currentUser = store.state.user!;
  currentUser.groups!.removeWhere((group) => group.id == id);
  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));

  return true;
}

/// Sends a request to join the group with the provided ID.
///
/// The [id] parameter is required and represents the ID of the group to join.
Future<bool> joinGroup(String id) async {
  try {
    await runApiService(
      apiCall: () => service.joinGroup(id),
      shouldRethrow: true,
    );
  } on ApiException catch (e) {
    showToast(e.message);
    return false;
  } catch (e) {
    showToast('Die Gruppe konnte nicht beigetreten werden.');
    return false;
  }

  showToast('Anfrage wurde gesendet');
  return true;
}

/// Leaves the group with the provided ID.
///
/// The [id] parameter is required and represents the ID of the group to leave.
Future<bool> leaveGroup(String id) async {
  try {
    await runApiService(
      apiCall: () => service.removeMember(id, store.state.user?.id ?? ''),
      shouldRethrow: true,
    );
  } on ApiException catch (e) {
    showToast(e.message);
    return false;
  } catch (e) {
    showToast('Die Gruppe konnte nicht verlassen werden.');
    return false;
  }

  // update groups of user
  final User currentUser = store.state.user!;
  currentUser.groups!.removeWhere((group) => group.id == id);

  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));

  return true;
}

/// Adds a member to the group with the provided ID.
///
/// The [id] and [userID] parameters are required and represent the ID of the group and the ID of the user to add, respectively.
Future<void> addMember(String id, String userID) async {
  try {
    await runApiService(
      apiCall: () => service.addMember(id, userID),
      shouldRethrow: true,
    );
  } on ApiException catch (e) {
    showToast(e.message);
    return;
  } catch (e) {
    showToast('Das Mitglied konnte nicht hinzugefügt werden.');
    return;
  }

  final Group? group = await runApiService(
    apiCall: () => service.loadGroupInfo(id),
    parser: (result) => Group.fromApi(result['group']),
  );

  if (group == null) {
    showToast('Die Gruppeninformationen konnte nicht geladen werden. Starte bitte die App neu.');
    return;
  }

  // update groups of user
  final User currentUser = store.state.user!;
  currentUser.groups = currentUser.groups!
      .map((e) => e.id == id ? group.update(messages: e.messages) : e)
      .toList();
  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));

  return;
}

/// Removes a member from the group with the provided ID.
///
/// The [id] and [userID] parameters are required and represent the ID of the group and the ID of the user to remove, respectively.
Future<bool> removeMember(String id, String userID) async {
  try {
    await runApiService(
      apiCall: () => service.removeMember(id, userID),
      shouldRethrow: true,
    );
  } on ApiException catch (e) {
    showToast(e.message);
    return false;
  } catch (e) {
    showToast('Das Mitglied konnte nicht entfernt werden.');
    return false;
  }

  final Group? group = await runApiService(
    apiCall: () => service.loadGroupInfo(id),
    parser: (result) => Group.fromApi(result['group']),
  );

  if (group == null) {
    showToast('Die Gruppeninformationen konnte nicht geladen werden. Starte bitte die App neu.');
    return true;
  }

  // update groups of user
  final User currentUser = store.state.user!;
  currentUser.groups = currentUser.groups!
      .map((e) => e.id == id ? group.update(messages: e.messages) : e)
      .toList();
  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));

  return true;
}

/// Removes a join request from the group with the provided ID.
///
/// The [groupID] and [userID] parameters are required and represent the ID of the group and the ID of the user whose join request is to be removed, respectively.
Future<bool> removeJoinRequest(String groupID, String userID) async {
  try {
    await runApiService(
      apiCall: () => service.removeJoinRequest(groupID, userID),
      parser: (result) => null,
    );
  } on ApiException catch (e) {
    showToast(e.message);
    return false;
  } catch (e) {
    showToast('Die Anfrage konnte nicht entfernt werden.');
    return false;
  }

  final Group? group = await runApiService(
    apiCall: () => service.loadGroupInfo(groupID),
    parser: (result) => Group.fromApi(result['group']),
  );

  if (group == null) {
    showToast('Die Gruppeninformationen konnte nicht geladen werden. Starte bitte die App neu.');
    return true;
  }

  // update groups of user
  final User currentUser = store.state.user!;
  currentUser.groups = currentUser.groups!
      .map((e) => e.id == groupID ? group.update(messages: e.messages) : e)
      .toList();
  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));

  return true;
}

Future<bool> uploadGroupImage(String id, XFile file) async {
  Uint8List content;
  try {
    content = await file.readAsBytes();
  } catch (e) {
    showToast('Das Bild war fehlerhaft.');
    return false;
  }

  try {
    await runRestApi(
      apiCall: () => rest_service.uploadGroupImage(id, content),
      shouldRethrow: true,
    );
  } on ApiException catch (e) {
    showToast(e.message);
    return false;
  } catch (e) {
    showToast('Das Bild konnte nicht hochgeladen werden.');
    return false;
  }

  // update groups of user
  final User currentUser = store.state.user!;
  currentUser.groups = currentUser.groups!.map((group) {
    if (group.id == id) {
      return group.update(imageExists: true);
    }
    return group;
  }).toList();

  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));

  await DefaultCacheManager().removeFile('$backendURL/api/group/$id/image');
  await DefaultCacheManager().downloadFile('$backendURL/api/group/$id/image');

  showToast('Profilbild erfolgreich hochgeladen.');
  return true;
}

Future<bool> deleteGroupImage(String id) async {
  try {
    await runRestApi(
        apiCall: () => rest_service.deleteGroupImage(id),
        shouldRethrow: true,
    );
  } on ApiException catch (e) {
    showToast(e.message);
    return false;
  } catch (e) {
    showToast('Das Bild konnte nicht gelöscht werden.');
    return false;
  }

  store.dispatch(
    Action(
      ActionTypes.setProfileImageAvailable,
      payload: false,
    ),
  );

  // update groups of user
  final User currentUser = store.state.user!;
  currentUser.groups = currentUser.groups!.map((group) {
    if (group.id == id) {
      return group.update(imageExists: false);
    }
    return group;
  }).toList();

  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));

  await DefaultCacheManager().removeFile('$backendURL/api/group/$id/image');

  showToast(
      'Profilbild erfolgreich gelöscht. Evtl. liegt das Bild noch im Cache.');

  return true;
}
