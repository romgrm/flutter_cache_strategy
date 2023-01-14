import 'package:example/data/datasource/fetch_data_impl.dart';
import 'package:example/data/domain/meal.entity.dart';
import 'package:example/data/dto/meal.dto.dart' as MealDto;
import 'package:example/main.dart';

import 'package:flutter_cache_strategy/strategies/async_or_cache_strategy.dart';
import 'package:flutter_cache_strategy/cache_strategy_package.dart';

class FrenchFoodRepository {
  final provider = FetchDataImpl();
  Future<List<MealEntity>> getData() async {
    final List<MealDto.MealDto>? testFrench = await CacheStrategyPackage.instance.execute(
      defaultSessionName: "ho",
      serializer: (p0) => MealDto.MealDto.fromData(p0),
      async: () => provider.getFrenchFood(),
      strategy: AsyncOrCacheStrategy(),
    );

    if (testFrench != null) {
      return List<MealEntity>.from(testFrench.map((mealDto) => mealDto.toEntity()));
    }
    return [];
  }
}
