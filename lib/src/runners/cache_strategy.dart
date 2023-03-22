import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../storage/storage.dart';
import '../utils/cache_strategy_error.dart';
import 'cache_manager.dart';
import 'cache_wrapper.dart';

abstract class CacheStrategy {
  Future _storeCacheData<T>(String keyCache, String boxeName, T value, Storage storage, bool isEncrypted) async {
    final cacheWrapper = CacheWrapper<T>(value, DateTime.now().millisecondsSinceEpoch);
    try {
      await storage.write(keyCache, jsonEncode(cacheWrapper.toJsonObject()), boxeName, isEncrypted);
    } catch (e) {
      throw CacheStrategyError("The data for $keyCache couldn't be stored in cache");
    }
  }

  _isValid<T>(CacheWrapper<T> cacheWrapper, bool keepExpiredCache, int ttlValue) => keepExpiredCache || DateTime.now().millisecondsSinceEpoch < cacheWrapper.cachedDate + ttlValue;

  Future<T> invokeAsync<T>(AsyncBloc<T>? asyncBloc, String keyCache, String boxeName, Storage storage, bool isEncrypted) async {
    try {
      final asyncData = await asyncBloc;
      _storeCacheData(keyCache, boxeName, asyncData, storage, isEncrypted);
      return asyncData;
    } catch (e) {
      rethrow;
    }
  }

  Future<T?> fetchCacheData<T>(String keyCache, String boxeName, SerializerBloc serializerBloc, Storage storage, int ttlValue, bool isEncrypted, {bool keepExpiredCache = false}) async {
    try {
      final value = await storage.read(keyCache, boxeName, isEncrypted);
      if (value != null) {
        final cacheWrapper = CacheWrapper.fromJson(jsonDecode(value));
        if (_isValid(cacheWrapper, keepExpiredCache, ttlValue)) {
          if (kDebugMode) print("Fetch cache data for key $keyCache: ${cacheWrapper.data}");
          return serializerBloc(cacheWrapper.data);
        }
      } else {
        if (kDebugMode) print("No cache data found for $keyCache");
        return null;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<T?> applyStrategy<T>(AsyncBloc<T>? asyncBloc, String keyCache, String boxeName, SerializerBloc serializerBloc, int ttlValue, Storage storage, bool isEncrypted);
}
