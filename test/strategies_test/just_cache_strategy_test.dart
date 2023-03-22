// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'package:flutter_cache_strategy/cache_strategy_package.dart';
import 'package:flutter_cache_strategy/src/runners/cache_wrapper.dart';
import 'package:flutter_cache_strategy/src/storage/cache_storage_impl.dart';

import '../dto/cache_value.dto.dart';
import '../mocks/mocks.dart';

late MockHiveInterface _mockHiveInterface;
late MockHiveBox _mockHiveBox;
late JustCacheStrategy _cacheStrategy;
void main() {
  group("testing of JustCacheStrategy", (() {
    setUpAll(() {
      _mockHiveInterface = MockHiveInterface();
      _mockHiveInterface.init('/test/hive_testing_path');
      PathProviderPlatform.instance = FakePathProviderPlatform();

      _mockHiveBox = MockHiveBox();
      _cacheStrategy = JustCacheStrategy();
    });
  }));

  String keyCache = "key_cache";
  String boxeName = "box_cache";
  CacheValueDto cacheValueDto = CacheValueDto(id: 1, value: "cache_value");

  test(
    'should return value from cache if there is a value',
    () async {
      // arrange
      final cacheWrapper = CacheWrapper<CacheValueDto>(cacheValueDto, DateTime.now().millisecondsSinceEpoch);
      String jsonEncodeValue = jsonEncode(cacheWrapper.toJsonObject());

      when(() => _mockHiveInterface.openBox(boxeName, encryptionCipher: null)).thenAnswer((_) async => _mockHiveBox);
      when(() => _mockHiveInterface.boxExists(boxeName, path: any(named: "path"))).thenAnswer((invocation) => Future.value(true));

      when(() => _mockHiveBox.get(any())).thenAnswer((invocation) => Future.value(jsonEncodeValue));

      CacheStorage storage = CacheStorage.testing(_mockHiveInterface);

      // act
      final result = await _cacheStrategy.applyStrategy(null, keyCache, boxeName, (value) => CacheValueDto.fromJson(value), 3600000, storage, false);

      // assert
      expect(result, isA<CacheValueDto>());
      _mockHiveInterface.resetAdapters();
    },
  );
  test(
    "should throw an Error if the box doesn't exist",
    () async {
      // arrange

      when(() => _mockHiveInterface.openBox(boxeName, encryptionCipher: null)).thenAnswer((_) async => _mockHiveBox);
      when(() => _mockHiveInterface.boxExists(boxeName, path: any(named: "path"))).thenAnswer((invocation) => Future.value(false));

      CacheStorage storage = CacheStorage.testing(_mockHiveInterface);

      // act && assert
      expect(() => _cacheStrategy.applyStrategy(null, keyCache, boxeName, (value) => CacheValueDto.fromJson(value), 3600000, storage, false), throwsA(isA<Error>()));

      _mockHiveInterface.resetAdapters();
    },
  );
}
