abstract class Storage {
  Future<void> write(String key, String value, String boxeName, bool isEncrypted);

  Future<String?> read(String key, String boxeName, bool isEncrypted);

  Future<void> delete(String key, String boxeName, bool isEncrypted);

  Future<int> count({String? keyCache, required String boxeName, required bool isEncrypted});

  Future<void> clear({String? keyCache, required String boxeName, required bool isEncrypted});
}
