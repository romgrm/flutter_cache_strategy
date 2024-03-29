// ignore_for_file: unnecessary_null_comparison

import 'runners/cache_manager.dart';
import 'runners/cache_strategy.dart';
import 'storage/cache_storage_impl.dart';
import 'strategies/async_or_cache_strategy.dart';
import 'strategies/cache_or_async_strategy.dart';
import 'strategies/just_async_strategy.dart';
import 'strategies/just_cache_strategy.dart';
import 'utils/cache_strategy_error.dart';

class FlutterCacheStrategy {
  late CacheStorage? _cacheStorage;
  static late CacheManager _cacheManager;
  late bool _isEncrypted;

  factory FlutterCacheStrategy() {
    return instance;
  }

  FlutterCacheStrategy._internal();

  static final FlutterCacheStrategy instance = FlutterCacheStrategy._internal();

  /// **[keyCache]** The key that references the data stored in the cache. A *keyCache* should be unique to each value. If it's not, values that have the same keyCache are combined.
  /// You can create a cache session with multiple store objects that each have a *keyCache*, but are combined into a single *boxeName*.
  ///
  /// **[boxeName]** The name of the box that contains the *keyCache* and their data.
  /// If you do not specify a *boxeName*, a default value will be used to create a single boxe throughout the application.
  /// *boxeName* can contain multiple values with multiple *keyCache*.
  ///
  /// **[serializer]** The serializer to convert the Json received from the cache to your Dart object.
  ///
  /// **[async]** The call to your remote (API, WebService...) to retrieve the data. It must be a Future.
  ///
  /// **[strategy]** The chosen strategy. You can choose between *[AsyncOrCacheStrategy]*, *[CacheOrAsyncStrategy]*, *[JustCacheStrategy]* or *[JustAsyncStrategy]*.
  ///
  /// **[timeToLiveValue]** The time during which the stored data will be valid. Once this value is exceeded, the cache will no longer be valid.
  /// If no value is set, the default value is 3 600 000 milliseconds, equivalent to **1 hour**.
  ///
  /// **[isEncrypted]** If it set on *true*, the boxe where stored data will be encrypted with [HiveAesCipher].
  ///
  Future execute<T>({
    required String keyCache,
    String? boxeName,
    required SerializerBloc serializer,
    AsyncBloc? async,
    required CacheStrategy strategy,
    int timeToLiveValue = 60 * 60 * 1000,
    bool isEncrypted = false,
  }) async {
    _cacheStorage = CacheStorage();
    _cacheManager = CacheManager(_cacheStorage!, boxeName);
    _isEncrypted = isEncrypted;

    assert(
        strategy is AsyncOrCacheStrategy ||
                strategy is CacheOrAsyncStrategy ||
                strategy is JustAsyncStrategy
            ? async != null
            : async == null || async != null,
        "\n\nasync cannot be null if you want a remote strategy like $AsyncOrCacheStrategy | $CacheOrAsyncStrategy | $JustAsyncStrategy");
    assert(keyCache.isNotEmpty,
        "\n\nkeyCache is used to store the data in the device and retrieve it easily, it cannot be empty");
    assert(timeToLiveValue > 60000);

    try {
      return await _cacheManager
          .from<T>(keyCache)
          .withSerializer(serializer)
          .withAsync(async)
          .withStrategy(strategy)
          .withTtl(timeToLiveValue)
          .withEncryption(isEncrypted)
          .execute();
    } catch (e) {
      rethrow;
    }
  }

  /// If you specify the *keyCache*, it will fetch the corresponding stored data and delete it.
  ///
  ///  If you don't specify a key, it will delete all stored caches _(i.e. all *keyCache* and their associated data)_ in the box corresponding to the called instance.
  ///
  /// If other boxes are cached, **they will not be impacted**.
  Future<void> clearCache({String? keyCache}) async {
    try {
      await _cacheManager.clear(
          keyCache: keyCache, isEncrypted: instance._isEncrypted);
    } catch (e) {
      throw CacheStrategyError("The data from $keyCache couldn't be deleted");
    }
  }
}
