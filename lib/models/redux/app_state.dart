import 'package:studiconnect/models/user.dart';

class AppState {
  String? sessionID;
  int runningTasks = 0;
  User? user;

  bool get loading => runningTasks > 0;
}
