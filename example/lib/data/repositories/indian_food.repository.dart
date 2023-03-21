import 'package:example/data/datasource/fetch_data_impl.dart';
import 'package:example/data/domain/meal.entity.dart';
import 'package:example/data/dto/meal.dto.dart';

import 'package:flutter_cache_strategy/cache_strategy_package.dart';

class IndianFoodRepository {
  final provider = FetchDataImpl();

  Future<List<MealEntity>> getIndianFood() async {
    final List<MealDto>? indianFood = await CacheStrategyPackage.instance
        .execute(
      keyCache: "indianFood",
      boxeName: "BOXE NOT ENCRYPTED",
      serializer: (p0) => MealDto.fromData(p0),
      async: provider.getIndianFood(),
      strategy: JustAsyncStrategy(),
    )
        .onError((error, stackTrace) {
      throw error ?? Error();
    });

    if (indianFood != null) {
      for (var element in indianFood) {
        element.strFlag = "assets/icons/india.png";
      }
      return List<MealEntity>.from(indianFood.map((mealDto) => mealDto.toEntity()));
    }
    return [];
  }
}
