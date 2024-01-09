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

Future<void> searchGroups(String module, int radius) async {
  List<Group>? result = await runApiService(
    apiCall: () => search_service.searchGroups(module, radius),
    parser: (result) => (result['searchGroups'] as List<dynamic>)
        .map((group) => Group.fromApi(group))
        .toList(),
  );

  if (result == null) {
    log("searchGroups: result was null");
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
    log("createGroup: id was null");
    return;
  }

  Group? group = await runApiService(
    apiCall: () => service.loadGroupInfo(id),
    parser: (result) => Group.fromApi(result['group']),
  );

  if (group == null) {
    log("createGroup: group was null");
    return;
  }

  // update groups of user
  User currentUser = store.state.user!;
  currentUser.groups!.add(group);
  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));
}

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
    showToast("Die Gruppe konnte nicht aktualisiert werden.");
    return false;
  }

  Group? group = await runApiService(
    apiCall: () => service.loadGroupInfo(id),
    parser: (result) => Group.fromApi(result['group']),
  );

  if (group == null) {
    showToast("Die Gruppeninformationen konnte nicht geladen werden.");
    return false;
  }

  // update groups of user
  User currentUser = store.state.user!;
  currentUser.groups =
      currentUser.groups!.map((e) => e.id == id ? group : e).toList();
  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));

  return true;
}

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
    showToast("Die Gruppe konnte nicht gelöscht werden.");
    return false;
  }

  // update groups of user
  User currentUser = store.state.user!;
  currentUser.groups!.removeWhere((group) => group.id == id);
  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));

  return true;
}

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
    showToast("Die Gruppe konnte nicht beigetreten werden.");
    return false;
  }

  showToast("Anfrage wurde gesendet");
  return true;
}

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
    showToast("Die Gruppe konnte nicht verlassen werden.");
    return false;
  }

  // update groups of user
  User currentUser = store.state.user!;
  currentUser.groups!.removeWhere((group) => group.id == id);

  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));

  return true;
}

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
    showToast("Das Mitglied konnte nicht hinzugefügt werden.");
    return;
  }

  Group? group = await runApiService(
    apiCall: () => service.loadGroupInfo(id),
    parser: (result) => Group.fromApi(result['group']),
  );

  if (group == null) {
    showToast("Die Gruppeninformationen konnte nicht geladen werden. Starte bitte die App neu.");
    return;
  }

  // update groups of user
  User currentUser = store.state.user!;
  currentUser.groups =
      currentUser.groups!.map((e) => e.id == id ? group : e).toList();
  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));

  return;
}

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
    showToast("Das Mitglied konnte nicht entfernt werden.");
    return false;
  }

  Group? group = await runApiService(
    apiCall: () => service.loadGroupInfo(id),
    parser: (result) => Group.fromApi(result['group']),
  );

  if (group == null) {
    showToast("Die Gruppeninformationen konnte nicht geladen werden. Starte bitte die App neu.");
    return true;
  }

  // update groups of user
  User currentUser = store.state.user!;
  currentUser.groups =
      currentUser.groups!.map((e) => e.id == id ? group : e).toList();
  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));

  return true;
}

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
    showToast("Die Anfrage konnte nicht entfernt werden.");
    return false;
  }

  Group? group = await runApiService(
    apiCall: () => service.loadGroupInfo(groupID),
    parser: (result) => Group.fromApi(result['group']),
  );

  if (group == null) {
    showToast("Die Gruppeninformationen konnte nicht geladen werden. Starte bitte die App neu.");
    return true;
  }

  // update groups of user
  User currentUser = store.state.user!;
  currentUser.groups =
      currentUser.groups!.map((e) => e.id == groupID ? group : e).toList();
  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));

  return true;
}

Future<bool> uploadGroupImage(String id, XFile file) async {
  Uint8List content;
  try {
    content = await file.readAsBytes();
  } catch (e) {
    showToast("Das Bild war fehlerhaft.");
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
    showToast("Das Bild konnte nicht hochgeladen werden.");
    return false;
  }

  // update groups of user
  User currentUser = store.state.user!;
  currentUser.groups = currentUser.groups!.map((group) {
    if (group.id == id) {
      return group.update(imageExists: true);
    }
    return group;
  }).toList();

  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));

  await DefaultCacheManager().removeFile("$backendURL/api/group/$id/image");
  await DefaultCacheManager().downloadFile("$backendURL/api/group/$id/image");

  showToast("Profilbild erfolgreich hochgeladen.");
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
    showToast("Das Bild konnte nicht gelöscht werden.");
    return false;
  }

  store.dispatch(
    Action(
      ActionTypes.setProfileImageAvailable,
      payload: false,
    ),
  );

  // update groups of user
  User currentUser = store.state.user!;
  currentUser.groups = currentUser.groups!.map((group) {
    if (group.id == id) {
      return group.update(imageExists: false);
    }
    return group;
  }).toList();

  store.dispatch(Action(ActionTypes.setUser, payload: currentUser));

  await DefaultCacheManager().removeFile("$backendURL/api/group/$id/image");

  showToast(
      "Profilbild erfolgreich gelöscht. Evtl. liegt das Bild noch im Cache.");

  return true;
}
