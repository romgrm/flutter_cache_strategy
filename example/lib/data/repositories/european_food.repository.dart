import 'package:example/core/rest/rest_exception.dart';
import 'package:example/data/datasource/fetch_data_impl.dart';
import 'package:example/data/domain/meal.entity.dart';
import 'package:example/data/dto/meal.dto.dart';
import 'package:flutter_cache_strategy/flutter_cache_strategy.dart';

class EuropeanFoodRepository {
  final _provider = FetchDataImpl();

  final _package = FlutterCacheStrategy();

  Future<List<MealEntity>> getEuropeanFood() async {
    final List<MealDto>? italianFood = await _package
        .execute<List<MealDto>>(
            keyCache: "italianFood",
            boxeName: "EUROPEAN BOXE",
            serializer: (data) => MealDto.fromData(data),
            async: _provider.getItalianFood(),
            strategy: AsyncOrCacheStrategy(),
            timeToLiveValue: 140000,
            isEncrypted: true)
        .onError((error, stackTrace) {
      throw error as RestException;
    });
    final List<MealDto>? frenchFood = await _package
        .execute<List<MealDto>>(
      keyCache: "frenchFood",
      boxeName: "EUROPEAN BOXE",
      serializer: (data) => MealDto.fromData(data),
      async: _provider.getFrenchFood(),
      strategy: AsyncOrCacheStrategy(),
      isEncrypted: true,
    )
        .onError((error, stackTrace) {
      throw error as RestException;
    });

    frenchFood?.forEach((e) => e.strFlag = "assets/icons/france.png");
    italianFood?.forEach((e) => e.strFlag = "assets/icons/italy.png");

    List<MealDto>? europeanFood = [...?frenchFood, ...?italianFood];

    return List<MealEntity>.from(europeanFood.map((mealDto) => mealDto.toEntity()));
  }

  Future<void> clear({String? keyCache}) async {
    await _package.clearCache(keyCache: keyCache);
  }
}
