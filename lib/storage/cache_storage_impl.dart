import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'storage.dart';

class CacheStorage implements Storage {
  static const _secureStorage = FlutterSecureStorage();
  static dynamic encryptionKey;

  CacheStorage._internal();

  static final CacheStorage instance = CacheStorage._internal();

  factory CacheStorage() {
    setUpHive();
    return instance;
  }

  static Future<void> setUpHive() async {
    await Hive.initFlutter();
  }

  static Future<List<int>> setUpEncryption() async {
    encryptionKey = await _secureStorage.read(key: 'key');
    if (encryptionKey == null) {
      final key = Hive.generateSecureKey();
      await _secureStorage.write(
        key: 'key',
        value: base64UrlEncode(key),
      );
    }
    final key = await _secureStorage.read(key: 'key');
    return encryptionKey = base64Url.decode(key!);
  }

  @override
  Future<void> clear({String? keyCache, required String boxeName, required bool isEncrypted}) async {
    if (isEncrypted) await setUpEncryption();
    final box = await Hive.openBox(boxeName, encryptionCipher: isEncrypted ? HiveAesCipher(encryptionKey) : null);
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
  Future<String?> read(String keyCache, String boxeName, bool isEncrypted) async {
    if (isEncrypted) await setUpEncryption();
    final box = await Hive.openBox(boxeName, encryptionCipher: isEncrypted ? HiveAesCipher(encryptionKey) : null);
    return box.get(keyCache);
  }

  @override
  Future<void> write(String keyCache, String value, String boxeName, bool isEncrypted) async {
    if (isEncrypted) await setUpEncryption();
    final box = await Hive.openBox(boxeName, encryptionCipher: isEncrypted ? HiveAesCipher(encryptionKey) : null);
    return box.put(keyCache, value);
  }

  @override
  Future<int> count({String? keyCache, required String boxeName, required bool isEncrypted}) async {
    if (isEncrypted) await setUpEncryption();
    final box = await Hive.openBox(boxeName, encryptionCipher: isEncrypted ? HiveAesCipher(encryptionKey) : null);
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
