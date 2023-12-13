import '../user.dart';

class AppState {
  int runningTasks = 0;
  User? user;

  bool get loading => runningTasks > 0;
}