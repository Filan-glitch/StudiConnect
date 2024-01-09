import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    stackTraceBeginIndex: 1,
    methodCount: 3,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    printTime: false,
  ),
);

void log(dynamic message) {
  logger.i(message);
}

void logError(dynamic message, Error error) {
  logger.e(message, error: error);
}

void logWarning(dynamic message) {
  logger.w(message);
}

void logDebug(dynamic message) {
  logger.d(message);
}

void logStackTrace(dynamic message, StackTrace stackTrace) {
  logger.t(message, stackTrace: stackTrace);
}

void logFatal(dynamic message) {
  logger.f(message);
}
