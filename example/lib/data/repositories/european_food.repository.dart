import 'package:example/data/datasource/fetch_data_impl.dart';
import 'package:example/data/domain/meal.entity.dart';
import 'package:example/data/dto/meal.dto.dart' as MealDto;
import 'package:example/main.dart';

import 'package:flutter_cache_strategy/strategies/async_or_cache_strategy.dart';
import 'package:flutter_cache_strategy/cache_strategy_package.dart';

class EuropeanFoodRepository {
  final provider = FetchDataImpl();

  final _package = CacheStrategyPackage();

  Future<List<MealEntity>> getEuropeanFood() async {
    final List<MealDto.MealDto>? italianFood = await _package.execute(
      keyCache: "italianFood",
      boxeName: "BOXE 1",
      serializer: (p0) => MealDto.MealDto.fromData(p0),
      async: provider.getItalianFood(),
      strategy: AsyncOrCacheStrategy(),
      timeToLiveValue: 140000,
    );
    final List<MealDto.MealDto>? frenchFood = await _package.execute(
      keyCache: "frenchFood",
      boxeName: "BOXE 1",
      serializer: (p0) => MealDto.MealDto.fromData(p0),
      async: provider.getFrenchFood(),
      strategy: AsyncOrCacheStrategy(),
    );

    List<MealDto.MealDto>? europeanFood = List.from(frenchFood ?? []);
    europeanFood.addAll(italianFood ?? []);

    return List<MealEntity>.from(europeanFood.map((mealDto) => mealDto.toEntity()));
  }

  Future<void> clear({String? keyCache}) async {
    await _package.clearCache(keyCache: keyCache);
  }
}
