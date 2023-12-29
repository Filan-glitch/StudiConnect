import 'package:studiconnect/models/group.dart';
import 'package:studiconnect/models/user.dart';

class AppState {
  int runningTasks = 0;
  bool get loading => runningTasks > 0;

  String? sessionID;
  User? user;

  List<Group> searchResults = [];
}
