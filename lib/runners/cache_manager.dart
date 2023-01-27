import '../storage/cache_storage_impl.dart';
import 'cache_strategy.dart';

typedef AsyncBloc<T> = Future;

typedef SerializerBloc<T> = Function(dynamic);

class CacheManager {
  late CacheStorage cacheStorage;
  late String _boxeName;

  factory CacheManager(CacheStorage cacheStorage, String? boxeName) {
    instance.cacheStorage = cacheStorage;
    instance._boxeName = boxeName ?? "cache";
    return instance;
  }

  CacheManager._internal();

  static final CacheManager instance = CacheManager._internal();

  StrategyBuilder from<T>(String keyCache) => StrategyBuilder<T>(keyCache, cacheStorage).withBoxeName(instance._boxeName);

  Future clear({String? keyCache}) async {
    if (keyCache != null) {
      keyCache = "${_boxeName}_$keyCache";
    }
    await cacheStorage.clear(keyCache: keyCache, boxeName: instance._boxeName);
  }
}

class StrategyBuilder<T> {
  late String _keyCache;
  late String _boxeName;
  late int _ttlValue;
  late CacheStorage _cacheStorage;
  late AsyncBloc<T> _asyncBloc;
  late SerializerBloc<T> _serializerBloc;
  late CacheStrategy _strategy;

  StrategyBuilder(String keyCache, CacheStorage cacheStorage) {
    _keyCache = keyCache;
    _cacheStorage = cacheStorage;
  }

  StrategyBuilder withAsync(AsyncBloc<T> asyncBloc) {
    _asyncBloc = asyncBloc;
    return this;
  }

  StrategyBuilder withStrategy(CacheStrategy strategyType) {
    _strategy = strategyType;
    return this;
  }

  StrategyBuilder withTtl(int ttlValue) {
    _ttlValue = ttlValue;
    return this;
  }

  StrategyBuilder withBoxeName(String boxeName) {
    _boxeName = boxeName;
    return this;
  }

  StrategyBuilder withSerializer(SerializerBloc serializerBloc) {
    _serializerBloc = serializerBloc;
    return this;
  }

  String buildSessionKey(String keyCache) => "${_boxeName}_$_keyCache";

  Future<T?> execute() async {
    try {
      return await _strategy.applyStrategy<T?>(_asyncBloc, buildSessionKey(_keyCache), _boxeName, _serializerBloc, _ttlValue, _cacheStorage);
    } catch (exception) {
      return null;
    }
  }
}
