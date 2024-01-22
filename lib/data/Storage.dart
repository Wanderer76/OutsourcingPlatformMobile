import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();


  Future<void> addNewItem(String key, String value, String? username) async {
    await storage.write(
      key: key,
      value: value,
      iOptions: _getIOSOptions(username),
      aOptions: _getAndroidOptions(),
    );
    if (kDebugMode) {
      print("saved $key: $value");
    }
  }

  Future<String?> getItem(String key, String? username) async {
    return await storage.read(
        key: key,
        iOptions: _getIOSOptions(username),
        aOptions: _getAndroidOptions()
    );
  }

  IOSOptions _getIOSOptions(String? username) => IOSOptions(
    accountName: username != null && username.isNotEmpty ? username : "defaultUser",
  );

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
    // sharedPreferencesName: 'Test2',
    // preferencesKeyPrefix: 'Test'
  );

}