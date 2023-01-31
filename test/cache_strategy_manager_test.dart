import 'package:flutter_cache_strategy/src/main.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

class MockCacheStrategyManager extends Mock implements CacheStrategyPackage {}

// class MockStrategyBuilder extends Mock implements StrategyBuilder {}

late MockCacheStrategyManager _mockCacheStrategyManager;
// late MockStrategyBuilder _mockStrategyBuilder;

void main() {
  setUp(() {
    _mockCacheStrategyManager = MockCacheStrategyManager();
    // _mockStrategyBuilder = MockStrategyBuilder();
  });

  group('should retrieved necessary elements to setup CacheStrategymanager', () {
    test(
      'should have a class CacheStrategyManager ',
      () async {
        // assert
        expect(_mockCacheStrategyManager, isA<CacheStrategyPackage>());
      },
    );

    // test(
    //   'should have an instance of StrategyBuilder',
    //   () async {
    //     // assert

    //     expect(_mockStrategyBuilder, isA<MockStrategyBuilder>());
    //   },
    // );
  });
}
