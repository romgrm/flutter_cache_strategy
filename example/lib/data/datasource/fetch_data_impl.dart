import 'package:example/core/rest/rest_manager.dart';
import 'package:example/data/datasource/fetch_data.dart';
import 'package:example/data/dto/meal.dto.dart';

class FetchDataImpl implements FetchData {
  final provider = RestManager();
  @override
  Future<List<MealDto>?> getFrenchFood() async {
    final json = await provider.get(path: "https://www.themealdb.com/api/json/v1/1/filter.php?a=French");

    return List<MealDto>.from(json['meals'].map<MealDto>((meal) => MealDto.fromJson(meal)));
  }

  @override
  Future<List<MealDto>?> getItalianFood() async {
    final json = await provider.get(path: "https://www.themealdb.com/api/json/v1/1/filter.php?a=Italian");

    return List<MealDto>.from(json['meals'].map<MealDto>((meal) => MealDto.fromJson(meal)));
  }

  @override
  Future<List<MealDto>?> getIndianFood() async {
    final json = await provider.get(path: "https://www.themealdb.com/api/json/v1/1/filter.php?a=Indian");

    return List<MealDto>.from(json['meals'].map<MealDto>((meal) => MealDto.fromJson(meal)));
  }
}
