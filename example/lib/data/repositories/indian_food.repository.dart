import 'package:example/data/datasource/fetch_data_impl.dart';
import 'package:example/data/domain/meal.entity.dart';
import 'package:example/data/dto/meal.dto.dart' as MealDto;
import 'package:example/main.dart';

import 'package:flutter_cache_strategy/strategies/async_or_cache_strategy.dart';
import 'package:flutter_cache_strategy/cache_strategy_package.dart';

class IndianFoodRepository {
  final provider = FetchDataImpl();

  Future<List<MealEntity>> getIndianFood() async {
    final List<MealDto.MealDto>? indianFood = await CacheStrategyPackage.instance.execute(
      keyCache: "indianFood",
      boxeName: "BOXE 2",
      serializer: (p0) => MealDto.MealDto.fromData(p0),
      async: provider.getIndianFood(),
      strategy: AsyncOrCacheStrategy(),
    );

    if (indianFood != null) {
      return List<MealEntity>.from(indianFood.map((mealDto) => mealDto.toEntity()));
    }
    return [];
  }
}
