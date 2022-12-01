import 'package:hive_flutter/hive_flutter.dart';

import 'storage.dart';

class CacheStorage implements Storage {
  static const _hiveBoxName = "cache";

  CacheStorage() {}

  @override
  Future<void> clear({String? prefix}) async {
    final box = await Hive.openBox(_hiveBoxName);
    if (prefix == null) {
      await box.clear();
    } else {
      for (var key in box.keys) {
        if (key is String && key.startsWith(prefix)) {
          await box.delete(key);
        }
      }
    }
  }

  @override
  Future<void> delete(String key) async {
    final box = await Hive.openBox(_hiveBoxName);
    return box.delete(key);
  }

  @override
  Future<String?> read(String key) async {
    final box = await Hive.openBox(_hiveBoxName);
    return box.get(key);
  }

  @override
  Future<void> write(String key, String value) async {
    final box = await Hive.openBox(_hiveBoxName);
    return box.put(key, value);
  }

  @override
  Future<int> count({String? prefix}) async {
    final box = await Hive.openBox(_hiveBoxName);
    if (prefix == null) {
      return box.length;
    } else {
      var count = 0;
      for (var key in box.keys) {
        if (key is String && key.startsWith(prefix)) {
          count++;
        }
      }
      return count;
    }
  }
}
