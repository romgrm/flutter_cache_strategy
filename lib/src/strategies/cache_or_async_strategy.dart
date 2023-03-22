import '../runners/cache_manager.dart';
import '../runners/cache_strategy.dart';
import '../storage/storage.dart';

/// The strategy will first call the cache to try and retrieve the corresponding stored data.
///
/// If _null_ is returned then the remote call is triggered with Rest error handling.
class CacheOrAsyncStrategy extends CacheStrategy {
  static final CacheOrAsyncStrategy _instance = CacheOrAsyncStrategy._internal();

  factory CacheOrAsyncStrategy() {
    return _instance;
  }

  CacheOrAsyncStrategy._internal();

  @override
  Future<T?> applyStrategy<T>(AsyncBloc<T>? asyncBloc, String keyCache, String boxeName, SerializerBloc<T> serializerBloc, int ttlValue, Storage storage, bool isEncrypted) async =>
      await fetchCacheData(keyCache, boxeName, serializerBloc, storage, ttlValue, isEncrypted) ??
      await invokeAsync(asyncBloc, keyCache, boxeName, storage, isEncrypted).onError((error, stackTrace) => Future.error(error!));
}
