library flutter_cache_strategy;

import 'package:flutter_cache_strategy/runners/cache_manager.dart';

import 'package:flutter_cache_strategy/runners/cache_strategy.dart';
import 'package:flutter_cache_strategy/strategies/async_or_cache_strategy.dart';
import 'package:flutter_cache_strategy/strategies/cache_or_async_strategy.dart';
import 'package:flutter_cache_strategy/strategies/just_cache_strategy.dart';
import 'package:flutter_cache_strategy/strategies/just_async_strategy.dart';

import 'storage/cache_storage_impl.dart';

class CacheStrategyPackage {
  late CacheStorage _cacheStorage;
  static late CacheManager _cacheManager;

  factory CacheStrategyPackage() {
    return instance;
  }

  CacheStrategyPackage._internal();

  static final CacheStrategyPackage instance = CacheStrategyPackage._internal();

  /// **[keyCache]** The key that references the data stored in the cache. You can create a cache session with multiple store objects that each have a [keyCache], but are combined into a single [boxeName].
  ///
  /// **[boxeName]** The name of the box that contains the [keyCache] and their data.
  /// If you do not specify a [boxeName], a default value will be used to create a single boxe throughout the application.
  ///
  /// **[serializer]** The serializer to convert the Json received from the cache to your Dart object.
  ///
  /// **[async]** The call to your remote (API, WebService...) to retrieve the data. It must be a Future.
  ///
  /// **[strategy]** The chosen strategy. You can choose between [AsyncOrCacheStrategy], [CacheOrAsyncStrategy], [JustCacheStrategy] or [JustAsyncStrategy].
  ///
  /// **[timeToLiveValue]** The time during which the stored data will be valid. Once this value is exceeded, the cache will no longer be valid.
  /// If no value is set, the default value is 360000 milliseconds, equivalent to **1 hour**.
  Future execute(
      {required String keyCache, String? boxeName, required SerializerBloc serializer, required AsyncBloc async, required CacheStrategy strategy, int timeToLiveValue = 60 * 60 * 1000}) async {
    _cacheStorage = CacheStorage.instance;
    _cacheManager = CacheManager(_cacheStorage, boxeName);

    assert(keyCache.isNotEmpty);
    assert(timeToLiveValue > 60000);

    try {
      return await _cacheManager.from(keyCache).withSerializer(serializer).withAsync(async).withStrategy(strategy).withTtl(timeToLiveValue).execute();
    } catch (e) {
      rethrow;
    }
  }

  /// If you specify the [keyCache], it will fetch the corresponding stored data and delete it.
  ///
  ///  If you don't specify a key, it will delete all stored caches _(i.e. all [keyCache] and their associated data)_ in the box corresponding to the called instance.
  ///
  /// If other boxes are cached, **they will not be impacted**.
  Future<void> clearCache({String? keyCache}) async {
    await _cacheManager.clear(keyCache: keyCache);
  }
}

class MealDto {
  String name;
  MealDto({
    required this.name,
  });
}
