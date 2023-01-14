import '../runners/cache_manager.dart';
import '../runners/cache_strategy.dart';
import '../storage/storage.dart';

class JustCacheStrategy extends CacheStrategy {
  static final JustCacheStrategy _instance = JustCacheStrategy._internal();

  factory JustCacheStrategy() {
    return _instance;
  }

  JustCacheStrategy._internal();
  @override
  Future<T?> applyStrategy<T>(AsyncBloc<T> asyncBloc, String key, SerializerBloc<T> serializerBloc, int ttlValue, Storage storage) async =>
      await fetchCacheData(key, serializerBloc, storage, ttlValue: ttlValue);
}
