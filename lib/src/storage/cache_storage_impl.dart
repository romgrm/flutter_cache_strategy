import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/cache_strategy_error.dart';
import 'storage.dart';

class CacheStorage implements Storage {
  static const _secureStorage = FlutterSecureStorage();
  static late HiveInterface hiveInstance;
  static dynamic encryptionKey;
  static late Directory appDir;

  CacheStorage._internal();

  static final CacheStorage instance = CacheStorage._internal();

  factory CacheStorage() {
    setUpHive();
    return instance;
  }

  CacheStorage.testing(HiveInterface hiveMock) {
    hiveInstance = hiveMock;
    appDir = Directory.current;
  }

  static Future<void> setUpHive() async {
    hiveInstance = Hive;
    await hiveInstance.initFlutter();
  }

  static Future<List<int>> setUpEncryption() async {
    encryptionKey = await _secureStorage.read(key: 'key');
    if (encryptionKey == null) {
      final key = hiveInstance.generateSecureKey();
      await _secureStorage.write(
        key: 'key',
        value: base64UrlEncode(key),
      );
    }
    final key = await _secureStorage.read(key: 'key');
    return encryptionKey = base64Url.decode(key!);
  }

  @override
  Future<void> clear(
      {String? keyCache,
      required String boxeName,
      required bool isEncrypted}) async {
    if (isEncrypted) await setUpEncryption();
    final box = await hiveInstance.openBox(boxeName,
        encryptionCipher: isEncrypted ? HiveAesCipher(encryptionKey) : null);
    if (keyCache == null) {
      await box.clear();
    } else {
      for (var key in box.keys) {
        if (key is String && key.startsWith(keyCache)) {
          await box.delete(key);
        }
      }
    }
  }

  @override
  Future<String?> read(
      String keyCache, String boxeName, bool isEncrypted) async {
    appDir = await getApplicationDocumentsDirectory();
    bool isBoxExist = await hiveInstance.boxExists(boxeName, path: appDir.path);
    if (isBoxExist) {
      if (isEncrypted) await setUpEncryption();
      final box = await hiveInstance
          .openBox(boxeName,
              encryptionCipher:
                  isEncrypted ? HiveAesCipher(encryptionKey) : null)
          .onError((error, stackTrace) {
        throw error!;
      });
      return box.get(keyCache);
    } else {
      throw CacheStrategyError("You must create the box before calling it");
    }
  }

  @override
  Future<void> write(
      String keyCache, String value, String boxeName, bool isEncrypted) async {
    if (isEncrypted) await setUpEncryption();
    final box = await hiveInstance.openBox(boxeName,
        encryptionCipher: isEncrypted ? HiveAesCipher(encryptionKey) : null);
    return box.put(keyCache, value);
  }

  @override
  Future<int> count(
      {String? keyCache,
      required String boxeName,
      required bool isEncrypted}) async {
    if (isEncrypted) await setUpEncryption();
    final box = await hiveInstance.openBox(boxeName,
        encryptionCipher: isEncrypted ? HiveAesCipher(encryptionKey) : null);
    if (keyCache == null) {
      return box.length;
    } else {
      var count = 0;
      for (var key in box.keys) {
        if (key is String && key.startsWith(keyCache)) {
          count++;
        }
      }
      return count;
    }
  }
}
