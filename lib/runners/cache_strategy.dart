import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'cache_manager.dart';
import 'cache_wrapper.dart';
import '../storage/storage.dart';

abstract class CacheStrategy {
  Future _storeCacheData<T>(String keyCache, String boxeName, T value, Storage storage) async {
    final cacheWrapper = CacheWrapper<T>(value, DateTime.now().millisecondsSinceEpoch);
    await storage.write(keyCache, jsonEncode(cacheWrapper.toJsonObject()), boxeName);
  }

  _isValid<T>(CacheWrapper<T> cacheWrapper, bool keepExpiredCache, int ttlValue) => keepExpiredCache || DateTime.now().millisecondsSinceEpoch < cacheWrapper.cachedDate + ttlValue;

  Future<T> invokeAsync<T>(AsyncBloc<T> asyncBloc, String keyCache, String boxeName, Storage storage) async {
    final asyncData = await asyncBloc;
    _storeCacheData(keyCache, boxeName, asyncData, storage);
    return asyncData;
  }

  Future<T?> fetchCacheData<T>(String keyCache, String boxeName, SerializerBloc serializerBloc, Storage storage, int ttlValue, {bool keepExpiredCache = false}) async {
    final value = await storage.read(keyCache, boxeName);
    if (value != null) {
      final cacheWrapper = CacheWrapper.fromJson(jsonDecode(value));
      if (_isValid(cacheWrapper, keepExpiredCache, ttlValue)) {
        if (kDebugMode) print("Fetch cache data for key $keyCache: ${cacheWrapper.data}");
        return serializerBloc(cacheWrapper.data);
      }
    }
    if (kDebugMode) print("No cache data found");
    return null;
  }

  Future<T?> applyStrategy<T>(AsyncBloc<T> asyncBloc, String keyCache, String boxeName, SerializerBloc serializerBloc, int ttlValue, Storage storage);
}
