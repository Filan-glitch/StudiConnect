import 'package:studiconnect/models/group.dart';
import 'package:studiconnect/models/user.dart';

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
