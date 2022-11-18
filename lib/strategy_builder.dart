import 'package:flutter_cache_strategy/cache_storage.dart';

class StrategyBuilder<T> {
  final String? _key;
  final CacheStorage _cacheStorage;
  StrategyBuilder(this._key, this._cacheStorage);

  // late AsyncBloc<T> _asyncBloc;
  // late SerializerBloc<T> _serializerBloc;
  // late CacheStrategy _strategy;
  // int _ttlValue = CacheStrategy.defaultTTLValue;
  String? _sessionName;

  // StrategyBuilder withAsync(AsyncBloc<T> asyncBloc) {
  //   _asyncBloc = asyncBloc;
  //   return this;
  // }

  // StrategyBuilder withStrategy(StrategyType strategyType) {
  //   switch (strategyType) {
  //     case StrategyType.justAsync:
  //       _strategy = getIt<JustAsyncStrategy>();
  //       break;
  //     case StrategyType.justCache:
  //       _strategy = getIt<JustCacheStrategy>();
  //       break;
  //     case StrategyType.cacheOrAsync:
  //       _strategy = getIt<CacheOrAsyncStrategy>();
  //       break;
  //     case StrategyType.asyncOrCache:
  //       _strategy = getIt<AsyncOrCacheStrategy>();
  //       break;
  //   }
  //   return this;
  // }

  // StrategyBuilder withTtl(int ttlValue) {
  //   _ttlValue = ttlValue;
  //   return this;
  // }

  StrategyBuilder withSession(String? sessionName) {
    _sessionName = sessionName;
    return this;
  }

  // StrategyBuilder withSerializer(SerializerBloc serializerBloc) {
  //   _serializerBloc = serializerBloc;
  //   return this;
  // }

  // String buildSessionKey(String key) => _sessionName != null ? "${_sessionName}_$key" : key;

  // Future<T?> execute() async {
  //   try {
  //     return await _strategy.applyStrategy<T?>(_asyncBloc, buildSessionKey(_key), _serializerBloc, _ttlValue);
  //   } catch (exception) {
  //     rethrow;
  //   }
  // }
}
