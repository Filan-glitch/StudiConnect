class AppState {
  int runningTasks = 0;
  bool get loading => runningTasks > 0;
}