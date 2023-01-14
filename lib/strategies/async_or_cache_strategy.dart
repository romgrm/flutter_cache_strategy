import '../runners/cache_manager.dart';
import '../runners/cache_strategy.dart';
import '../storage/storage.dart';

class AsyncOrCacheStrategy extends CacheStrategy {
  static final AsyncOrCacheStrategy _instance = AsyncOrCacheStrategy._internal();

  factory AsyncOrCacheStrategy() {
    return _instance;
  }

  AsyncOrCacheStrategy._internal();

  @override
  Future<T?> applyStrategy<T>(AsyncBloc<T> asyncBloc, String key, SerializerBloc<T> serializerBloc, int ttlValue, Storage storage) async {
    return await invokeAsync(asyncBloc, key, storage).onError((err, stack) async {
      return await fetchCacheData(key, serializerBloc, storage, ttlValue: ttlValue) ?? Future.error(err!);
    });
    // return await invokeAsync(asyncBloc, key, storage).onError(
    //   (Error restError, stackTrace) async {
    //     return await fetchCacheData(key, serializerBloc, storage, ttlValue: ttlValue) ?? Future.error(restError);

    //     /* if (restError == 403 || restError == 404) {
    //         storage.clear(prefix: key);
    //         return Future.error(restError);
    //       } else {
    //         return await fetchCacheData(key, serializerBloc, storage, ttlValue: ttlValue) ?? Future.error(restError);
    //       } */
    //   },
    // );
  }
}
