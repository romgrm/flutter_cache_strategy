import 'package:flutter_cache_strategy/cache_strategy.dart';
import 'package:flutter_cache_strategy/strategy_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

class MockCacheStrategyManager extends Mock implements CacheStrategy {}

class MockStrategyBuilder extends Mock implements StrategyBuilder {}

late MockCacheStrategyManager _mockCacheStrategyManager;
late MockStrategyBuilder _mockStrategyBuilder;

void main() {
  setUp(() {
    _mockCacheStrategyManager = MockCacheStrategyManager();
    _mockStrategyBuilder = MockStrategyBuilder();
  });

  group('should retrieved necessary elements to setup CacheStrategymanager', () {
    test(
      'should have a class CacheStrategyManager ',
      () async {
        // assert
        expect(_mockCacheStrategyManager, isA<CacheStrategy>());
      },
    );

    test(
      'should have an instance of StrategyBuilder',
      () async {
        // assert

        expect(_mockStrategyBuilder, isA<MockStrategyBuilder>());
      },
    );
  });
}
