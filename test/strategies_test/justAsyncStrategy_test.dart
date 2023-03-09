import 'package:flutter_cache_strategy/cache_strategy_package.dart';
import 'package:flutter_cache_strategy/src/storage/cache_storage_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../dto/cache_value.dto.dart';
import '../mocks/mocks.dart';

late MockHiveInterface _mockHiveInterface;
late MockHiveBox _mockHiveBox;
late JustAsyncStrategy _cacheStrategy;
void main() {
  group("testing of JustAsyncStrategy", (() {
    setUpAll(() {
      _mockHiveInterface = MockHiveInterface();
      _mockHiveInterface.init('/test/hive_testing_path');

      _mockHiveBox = MockHiveBox();
      _cacheStrategy = JustAsyncStrategy();
    });

    String keyCache = "key_cache";
    String boxeName = "box_cache";
    CacheValueDto cacheValueDto = CacheValueDto(id: 1, value: "cache_value");

    test(
      'should return a value from remote and store it',
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
      'should throw an Error',
      () async {
        // arrange
        Future<Error> tryAsync() async => throw Error();

        CacheStorage storage = CacheStorage.testing(_mockHiveInterface);

        // act && assert
        expect(() => _cacheStrategy.applyStrategy(tryAsync(), keyCache, boxeName, (value) => CacheValueDto.fromJson(value), 3600000, storage, false), throwsA(isA<Error>()));
        _mockHiveInterface.resetAdapters();
      },
    );
  }));
}
