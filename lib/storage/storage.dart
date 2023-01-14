abstract class Storage {
  Future<void> write(String key, String value);

  Future<String?> read(String key);

  Future<void> delete(String key);

  Future<int> count({String? prefix});

  Future<void> clear({String? prefix});
}
