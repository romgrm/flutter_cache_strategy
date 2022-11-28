library flutter_cache_strategy;

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_strategy/cache_storage.dart';
import 'package:flutter_cache_strategy/strategy_builder.dart';

class CacheStrategy {
  static final CacheStrategy _instance = CacheStrategy._internal();

  factory CacheStrategy() {
    return _instance;
  }

  CacheStrategy._internal();

  String? defaultSessionName;

  final CacheStorage _cacheStorage = CacheStorage();

  StrategyBuilder from<T>(String key) => StrategyBuilder<T>(key, _cacheStorage).withSession(defaultSessionName);

  String tryToReturnText() {
    return "HELLO";
  }
}
