/// This library is part of the Redux state management system. It contains the [AppState] class.
///
/// {@category REDUX}
library models.redux.app_state;
import 'package:studiconnect/models/group.dart';
import 'package:studiconnect/models/user.dart';

/// Class representing the state of the application.
///
/// The state of the application includes the number of running tasks, the session ID,
/// the auth provider type, the current user, the availability of the profile image,
/// and the search results.
///
/// The [runningTasks] property represents the number of running tasks in the application.
/// It is initialized to 0.
///
/// The [loading] property is a getter that returns true if there are any running tasks,
/// and false otherwise.
///
/// The [connected] property represents whether the application is connected to the internet.
///
/// The [sessionID] property represents the session ID of the current user. It is nullable.
///
/// The [authProviderType] property represents the type of the auth provider. It is nullable.
///
/// The [user] property represents the current user. It is nullable.
///
/// The [profileImageAvailable] property represents whether the profile image is available.
/// It is initialized to false.
///
/// The [searchResults] property represents the search results. It is initialized to an empty list.
class AppState {
  int runningTasks = 0;
  bool get loading => runningTasks > 0;

  bool connected = true;
  String? sessionID;
  String? authProviderType;
  User? user;
  bool profileImageAvailable = false;

  List<Group> searchResults = [];
}