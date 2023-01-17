library flutter_cache_strategy;

import 'package:flutter_cache_strategy/runners/cache_manager.dart';
import 'package:flutter_cache_strategy/runners/cache_strategy.dart';
import 'package:isar/isar.dart';

import 'storage/cache_storage_impl.dart';

class CacheStrategyPackage {
  late CacheStorage _cacheStorage;
  static late CacheManager _cacheManager;

  CacheStrategyPackage._internal();

  static final CacheStrategyPackage instance = CacheStrategyPackage._internal();

  Future execute({required String defaultSessionName, required SerializerBloc serializer, required AsyncBloc async, required CacheStrategy strategy, required CollectionSchema schema}) async {
    _cacheStorage = CacheStorage.instance;
    _cacheManager = CacheManager(_cacheStorage);
    try {
      print(schema);
      return await _cacheManager.from(defaultSessionName).withSerializer(serializer).withAsync(async).withStrategy(strategy).execute();
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
