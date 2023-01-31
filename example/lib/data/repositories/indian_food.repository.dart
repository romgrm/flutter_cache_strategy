import 'package:example/data/datasource/fetch_data_impl.dart';
import 'package:example/data/domain/meal.entity.dart';
import 'package:example/data/dto/meal.dto.dart' as meal_dto;

import 'package:flutter_cache_strategy/cache_strategy_package.dart';

class IndianFoodRepository {
  final provider = FetchDataImpl();

  Future<List<MealEntity>> getIndianFood() async {
    final List<meal_dto.MealDto>? indianFood = await CacheStrategyPackage.instance.execute(
      keyCache: "indianFood",
      boxeName: "BOXE NOT ENCRYPTED",
      serializer: (p0) => meal_dto.MealDto.fromData(p0),
      async: provider.getIndianFood(),
      strategy: AsyncOrCacheStrategy(),
    );

    if (indianFood != null) {
      return List<MealEntity>.from(indianFood.map((mealDto) => mealDto.toEntity()));
    }
    return [];
  }
}
