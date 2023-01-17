abstract class Storage {
  Future<void> write(String key, String value, String boxeName);

  Future<String?> read(String key, String boxeName);

  Future<void> delete(String key, String boxeName);

  Future<int> count({String? keyCache, required String boxeName});

  Future<void> clear({String? keyCache, required String boxeName});
}
