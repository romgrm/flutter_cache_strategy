import 'package:example/data/datasource/fetch_data_impl.dart';
import 'package:example/data/domain/meal.entity.dart';
import 'package:example/data/dto/meal.dto.dart' as MealDto;
import 'package:example/main.dart';

import 'package:flutter_cache_strategy/strategies/async_or_cache_strategy.dart';
import 'package:flutter_cache_strategy/cache_strategy_package.dart';

class EnglishFoodRepository {
  final provider = FetchDataImpl();

  Future<List<MealEntity>> getEnglishFood() async {
    final List<MealDto.MealDto>? testEnglish = await CacheStrategyPackage.instance.execute(
      defaultSessionName: "hey",
      serializer: (p0) => MealDto.MealDto.fromData(p0),
      async: provider.getEnglishFood(),
      strategy: AsyncOrCacheStrategy(),
    );

    print(identical(CacheStrategyPackage.instance, CacheStrategyPackage.instance));

    if (testEnglish != null) {
      return List<MealEntity>.from(testEnglish.map((mealDto) => mealDto.toEntity()));
    }
    return [];
  }
}
