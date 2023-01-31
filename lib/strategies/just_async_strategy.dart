import 'package:flutter_cache_strategy/storage/storage.dart';

import '../runners/cache_manager.dart';
import '../runners/cache_strategy.dart';

/// Just call the remote with the usual Rest behaviour.
class JustAsyncStrategy extends CacheStrategy {
  static final JustAsyncStrategy _instance = JustAsyncStrategy._internal();

  factory JustAsyncStrategy() {
    return _instance;
  }

  JustAsyncStrategy._internal();

  @override
  Future<T?> applyStrategy<T>(AsyncBloc<T> asyncBloc, String keyCache, String boxeName, SerializerBloc<T> serializerBloc, int ttlValue, Storage storage, bool isEncrypted) async =>
      await invokeAsync(asyncBloc, keyCache, boxeName, storage, isEncrypted).onError((error, stackTrace) => Future.error(error!));
}
