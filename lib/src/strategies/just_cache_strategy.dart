import '../runners/cache_manager.dart';
import '../runners/cache_strategy.dart';
import '../storage/storage.dart';

/// Just try to get the corresponding data from the cache.
class JustCacheStrategy extends CacheStrategy {
  static final JustCacheStrategy _instance = JustCacheStrategy._internal();

  factory JustCacheStrategy() {
    return _instance;
  }

  JustCacheStrategy._internal();
  @override
  Future<T?> applyStrategy<T>(
          AsyncBloc<T>? asyncBloc,
          String keyCache,
          String boxeName,
          SerializerBloc<T> serializerBloc,
          int ttlValue,
          Storage storage,
          bool isEncrypted) async =>
      await fetchCacheData(
          keyCache, boxeName, serializerBloc, storage, ttlValue, isEncrypted);
}
