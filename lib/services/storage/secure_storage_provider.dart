import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Returns the Android options for secure storage.
///
/// The options are set to use encrypted shared preferences.
AndroidOptions _getAndroidOptions() => const AndroidOptions(
  encryptedSharedPreferences: true,
);

/// Returns the iOS options for secure storage.
///
/// The options are set to unlock the keychain at first unlock.
IOSOptions _getIOSOptions() => const IOSOptions(
  accessibility: KeychainAccessibility.first_unlock,
);

/// Provides a secure storage instance for storing sensitive data.
///
/// The instance is configured with platform-specific options for Android and iOS.
FlutterSecureStorage get secureStorage => FlutterSecureStorage(
  aOptions: _getAndroidOptions(),
  iOptions: _getIOSOptions()
);