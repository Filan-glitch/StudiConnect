/// This library contains a logger instance with custom configuration.
///
/// {@category SERVICES}
library services.logger_provider;

import 'package:logger/logger.dart';

/// Logger instance with custom configuration.
///
/// This logger uses the [PrettyPrinter] to format the logs.
/// The printer is configured to start the stack trace from the first index,
/// print 3 methods for info logs and 8 methods for error logs,
/// limit the line length to 120 characters,
/// use colors to differentiate between log levels,
/// print emojis to represent log levels,
/// and not print the time of the log.
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

/// Logs an info message.
///
/// The [message] parameter is required and represents the message to be logged.
void log(dynamic message) {
  logger.i(message);
}

/// Logs an error message along with the error.
///
/// The [message] parameter is required and represents the message to be logged.
/// The [error] parameter is required and represents the error to be logged.
void logError(dynamic message, Error error) {
  logger.e(message, error: error);
}

/// Logs a warning message.
///
/// The [message] parameter is required and represents the message to be logged.
void logWarning(dynamic message) {
  logger.w(message);
}

/// Logs a debug message.
///
/// The [message] parameter is required and represents the message to be logged.
void logDebug(dynamic message) {
  logger.d(message);
}

/// Logs a stack trace along with a message.
///
/// The [message] parameter is required and represents the message to be logged.
/// The [stackTrace] parameter is required and represents the stack trace to be logged.
void logStackTrace(dynamic message, StackTrace stackTrace) {
  logger.t(message, stackTrace: stackTrace);
}

/// Logs a fatal message.
///
/// The [message] parameter is required and represents the message to be logged.
void logFatal(dynamic message) {
  logger.f(message);
}