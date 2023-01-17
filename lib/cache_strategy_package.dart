library flutter_cache_strategy;

import 'package:flutter_cache_strategy/runners/cache_manager.dart';
import 'package:flutter_cache_strategy/runners/cache_strategy.dart';

import 'storage/cache_storage_impl.dart';

class CacheStrategyPackage {
  late CacheStorage _cacheStorage;
  static late CacheManager _cacheManager;

  CacheStrategyPackage._internal();

  static final CacheStrategyPackage instance = CacheStrategyPackage._internal();

  Future execute({required String defaultSessionName, required SerializerBloc serializer, required AsyncBloc async, required CacheStrategy strategy}) async {
  Future execute(
      {required String keyCache, String? boxeName, required SerializerBloc serializer, required AsyncBloc async, required CacheStrategy strategy, int? timeToLiveValue = 60 * 60 * 1000}) async {
    _cacheStorage = CacheStorage.instance;
    _cacheManager = CacheManager(_cacheStorage, boxeName);

    assert(keyCache.isNotEmpty);
    try {
      return await _cacheManager.from(keyCache).withSerializer(serializer).withAsync(async).withStrategy(strategy).execute();
    } catch (e) {
      rethrow;
    }
  }
}

class MealDto {
  String name;
  MealDto({
    required this.name,
  });
}
