import 'package:flutter_secure_storage/flutter_secure_storage.dart';

AndroidOptions _getAndroidOptions() => const AndroidOptions(
  encryptedSharedPreferences: true,
);

IOSOptions _getIOSOptions() => const IOSOptions(
  accessibility: KeychainAccessibility.first_unlock,
);

FlutterSecureStorage get secureStorage => FlutterSecureStorage(aOptions: _getAndroidOptions(), iOptions: _getIOSOptions());