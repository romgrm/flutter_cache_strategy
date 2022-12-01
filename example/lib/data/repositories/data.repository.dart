import 'package:example/data/datasource/fetch_data_impl.dart';
import 'package:example/data/domain/meal.entity.dart';

import 'package:flutter_cache_strategy/strategies/async_or_cache_strategy.dart';
import 'package:flutter_cache_strategy/cache_strategy_package.dart';

class DataRepository {
  final provider = FetchDataImpl();
  Future<List<MealEntity>> getData() async {
    final result = await CacheStrategyPackage().execute("test", (p0) => print(p0), () => print("async"), AsyncOrCacheStrategy());
    // final result = await provider.getData();
    if (result != null) {
      return List<MealEntity>.from(result.map((mealDto) => mealDto.toEntity()));
    }
    return [];
  }
}
