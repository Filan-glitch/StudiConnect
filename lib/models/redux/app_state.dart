/// This library is part of the Redux state management system. It contains the [AppState] class.
///
/// {@category REDUX}
library models.redux.app_state;

import 'package:studiconnect/models/group.dart';
import 'package:studiconnect/models/user.dart';

/// Class representing the state of the application.
///
/// The state of the application includes the number of running tasks, connection status, the session ID,
/// the auth provider type, the current user, the availability of the profile image,
/// and the search results.
class AppState {

  /// The number of running tasks.
  int runningTasks = 0;

  /// The boolean value indicating whether the user is connected.
  bool connected = true;

  /// The session ID.
  String? sessionID;

  /// The authentication provider type.
  String? authProviderType;

  /// The current user.
  User? user;

  /// The boolean value indicating whether the profile image is available.
  bool profileImageAvailable = false;

  /// The search results.
  List<Group> searchResults = [];

  /// The boolean value indicating whether the app is loading.
  bool get loading => runningTasks > 0;
}