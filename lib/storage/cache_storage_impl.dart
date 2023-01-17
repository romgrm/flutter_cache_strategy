import 'package:hive_flutter/hive_flutter.dart';

import 'storage.dart';

class CacheStorage implements Storage {
  CacheStorage._internal();

  static final CacheStorage instance = CacheStorage._internal();

  @override
  Future<void> clear({String? keyCache, required String boxeName}) async {
    final box = await Hive.openBox(boxeName);
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
  Future<void> delete(String keyCache, String boxeName) async {
    final box = await Hive.openBox(boxeName);
    return box.delete(keyCache);
  }

  @override
  Future<String?> read(String keyCache, String boxeName) async {
    final box = await Hive.openBox(boxeName);
    return box.get(keyCache);
  }

  @override
  Future<void> write(String keyCache, String value, String boxeName) async {
    final box = await Hive.openBox(boxeName);
    return box.put(keyCache, value);
  }

  @override
  Future<int> count({String? keyCache, required String boxeName}) async {
    final box = await Hive.openBox(boxeName);
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
