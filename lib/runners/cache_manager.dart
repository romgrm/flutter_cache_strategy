import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../storage/cache_storage_impl.dart';
import 'cache_strategy.dart';

typedef AsyncBloc<T> = Function;

typedef SerializerBloc<T> = Function(dynamic);

class CacheManager {
  late CacheStorage cacheStorage;

  factory CacheManager(CacheStorage cacheStorage) {
    instance.cacheStorage = cacheStorage;
    return instance;
  }

  CacheManager._internal();

  static final CacheManager instance = CacheManager._internal();

  String? defaultSessionName;

  StrategyBuilder from<T>(String key) => StrategyBuilder<T>(key, cacheStorage).withSession(defaultSessionName); // pass cacheStorage

  Future clear({String? prefix}) async {
    if (defaultSessionName != null && prefix != null) {
      await cacheStorage.clear(prefix: "${defaultSessionName}_$prefix");
    } else if (prefix != null) {
      await cacheStorage.clear(prefix: prefix);
    } else if (defaultSessionName != null) {
      await cacheStorage.clear(prefix: defaultSessionName);
    } else {
      await cacheStorage.clear();
    }
  }
}

class StrategyBuilder<T> {
  late String _key;
  late CacheStorage _cacheStorage;

  StrategyBuilder(String key, CacheStorage cacheStorage) {
    _key = key;
    _cacheStorage = cacheStorage;
  }

  late AsyncBloc<T> _asyncBloc;
  late SerializerBloc<T> _serializerBloc;
  late CacheStrategy _strategy;
  int _ttlValue = CacheStrategy.defaultTTLValue;
  String? _sessionName;

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

  StrategyBuilder withSession(String? sessionName) {
    _sessionName = sessionName;
    return this;
  }

  StrategyBuilder withSerializer(SerializerBloc serializerBloc) {
    _serializerBloc = serializerBloc;
    return this;
  }

  String buildSessionKey(String key) => _sessionName != null ? "${_sessionName}_$key" : key;

  Future<T?> execute() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();

    await Hive.initFlutter(appDocumentDirectory.path);
    try {
      return await _strategy.applyStrategy<T?>(_asyncBloc, buildSessionKey(_key), _serializerBloc, _ttlValue, _cacheStorage);
    } catch (exception) {
      rethrow;
    }
  }
}
