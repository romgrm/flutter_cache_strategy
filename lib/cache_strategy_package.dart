library flutter_cache_strategy;

import 'package:flutter_cache_strategy/runners/cache_manager.dart';
import 'package:flutter_cache_strategy/runners/cache_strategy.dart';

import 'storage/cache_storage_impl.dart';

class CacheStrategyPackage<T> {
  static final CacheStrategyPackage _instance = CacheStrategyPackage._internal();
  static late CacheStorage _cacheStorage;
  static late CacheManager _cacheManager;

  factory CacheStrategyPackage() {
    _cacheStorage = CacheStorage();
    _cacheManager = CacheManager(_cacheStorage);
    return _instance as CacheStrategyPackage<T>;
  }

  CacheStrategyPackage._internal();

  Future<T?> execute(String defaultSessionName, SerializerBloc serializer, AsyncBloc async, CacheStrategy strategy) async {
    T? result = await _cacheManager.from<T>(defaultSessionName).withSerializer(serializer).withAsync(async).withStrategy(strategy).execute();
    result = MealDto(name: "test") as T;
    return result;
  }
}

class MealDto {
  String name;
  MealDto({
    required this.name,
  });
}
