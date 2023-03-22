import '../runners/cache_manager.dart';
import '../runners/cache_strategy.dart';
import '../storage/storage.dart';

/// First, triggering the remote call, if an error is throw, the strategy will trigger the [fetchCacheData] which will attempt to retrieve the corresponding data stored in the cache.
class AsyncOrCacheStrategy extends CacheStrategy {
  static final AsyncOrCacheStrategy _instance = AsyncOrCacheStrategy._internal();

  factory AsyncOrCacheStrategy() {
    return _instance;
  }

  AsyncOrCacheStrategy._internal();

  @override
  Future<T?> applyStrategy<T>(AsyncBloc<T>? asyncBloc, String keyCache, String boxeName, SerializerBloc<T> serializerBloc, int ttlValue, Storage storage, bool isEncrypted) async {
    return await invokeAsync(asyncBloc, keyCache, boxeName, storage, isEncrypted).onError((err, stack) async {
      return await fetchCacheData(keyCache, boxeName, serializerBloc, storage, ttlValue, isEncrypted);
    });
  }
}
