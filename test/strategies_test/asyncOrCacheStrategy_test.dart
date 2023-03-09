import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_cache_strategy/cache_strategy_package.dart';
import 'package:flutter_cache_strategy/src/runners/cache_wrapper.dart';
import 'package:flutter_cache_strategy/src/storage/cache_storage_impl.dart';
import 'dart:convert';

import '../dto/cache_value.dto.dart';
import '../mocks/mocks.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

late MockHiveInterface _mockHiveInterface;
late MockHiveBox _mockHiveBox;
late AsyncOrCacheStrategy _cacheStrategy;
void main() {
  group("testing of AsyncOrCacheStrategy", (() {
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      PathProviderPlatform.instance = FakePathProviderPlatform();

      _mockHiveInterface = MockHiveInterface();
      _mockHiveInterface.init('/test/hive_testing_path');

      _mockHiveBox = MockHiveBox();
      _cacheStrategy = AsyncOrCacheStrategy();
    });

    String keyCache = "key_cache";
    String boxeName = "box_cache";
    CacheValueDto cacheValueDto = CacheValueDto(id: 1, value: "cache_value");

    test(
      'should return a value from remote',
      () async {
        // arrange
        Future<CacheValueDto> tryAsync() async => cacheValueDto;

        when(() => _mockHiveInterface.openBox(boxeName, encryptionCipher: null)).thenAnswer((_) async => _mockHiveBox);

        when(() => _mockHiveBox.put(any(), any())).thenAnswer((realInvocation) async => Future<void>);

        CacheStorage storage = CacheStorage.testing(_mockHiveInterface);

        // act
        final result = await _cacheStrategy.applyStrategy(tryAsync(), keyCache, boxeName, (value) => CacheValueDto.fromJson(value), 3600000, storage, false);

        // assert
        verify(() => _mockHiveInterface.openBox(boxeName, encryptionCipher: null)).called(1);
        expect(result, isA<CacheValueDto>());
        expect(result, cacheValueDto);
        _mockHiveInterface.resetAdapters();
      },
    );
    test(
      'should return a value from cache',
      () async {
        // arrange
        String keyCache = "key_cache";
        String boxeName = "box_cache";
        CacheValueDto cacheValueDto = CacheValueDto(id: 1, value: "cache_value");

        final cacheWrapper = CacheWrapper<CacheValueDto>(cacheValueDto, DateTime.now().millisecondsSinceEpoch);
        String jsonEncodeValue = jsonEncode(cacheWrapper.toJsonObject());

        Future<CacheValueDto> tryAsync() async {
          throw Error();
        }

        when(() => _mockHiveInterface.openBox(boxeName, encryptionCipher: null)).thenAnswer((_) async => _mockHiveBox);

        when(() => _mockHiveInterface.boxExists(boxeName, path: any(named: "path"))).thenAnswer((invocation) => Future.value(true));

        when(() => _mockHiveBox.get(any())).thenAnswer((invocation) => Future.value(jsonEncodeValue));

        CacheStorage storage = CacheStorage.testing(_mockHiveInterface);

        // act
        final result = await _cacheStrategy.applyStrategy(tryAsync(), keyCache, boxeName, (value) => CacheValueDto.fromJson(value), 3600000, storage, false);

        // assert
        expect(result, isA<CacheValueDto>());
        _mockHiveInterface.resetAdapters();
      },
    );
  }));
}
