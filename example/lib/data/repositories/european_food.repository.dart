import 'package:example/data/datasource/fetch_data_impl.dart';
import 'package:example/data/domain/meal.entity.dart';
import 'package:example/data/dto/meal.dto.dart' as meal_dto;
import 'package:flutter_cache_strategy/cache_strategy_package.dart';

class EuropeanFoodRepository {
  final provider = FetchDataImpl();

  final _package = CacheStrategyPackage();

  Future<List<MealEntity>> getEuropeanFood() async {
    final List<meal_dto.MealDto>? italianFood = await _package.execute(
        keyCache: "italianFood",
        boxeName: "BOXE ENCRYPTED",
        serializer: (p0) => meal_dto.MealDto.fromData(p0),
        async: provider.getItalianFood(),
        strategy: AsyncOrCacheStrategy(),
        timeToLiveValue: 140000,
        isEncrypted: true);
    final List<meal_dto.MealDto>? frenchFood = await _package.execute(
      keyCache: "frenchFood",
      boxeName: "BOXE ENCRYPTED",
      serializer: (p0) => meal_dto.MealDto.fromData(p0),
      async: provider.getFrenchFood(),
      strategy: AsyncOrCacheStrategy(),
      isEncrypted: false,
    );

    List<meal_dto.MealDto>? europeanFood = List.from(frenchFood ?? []);
    europeanFood.addAll(italianFood ?? []);

    return List<MealEntity>.from(europeanFood.map((mealDto) => mealDto.toEntity()));
  }

  Future<void> clear({String? keyCache}) async {
    await _package.clearCache(keyCache: keyCache);
  }
}
