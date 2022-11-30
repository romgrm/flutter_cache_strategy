import 'dart:convert';

import 'package:example/core/rest_manager.dart';
import 'package:example/data/datasource/fetch_data.dart';
import 'package:example/data/dto/meal.dto.dart';

class FetchDataImpl implements FetchData {
  final provider = RestManager();
  @override
  Future<List<MealDto>?> getData() async {
    final json = await provider.get(path: "https://www.themealdb.com/api/json/v1/1/filter.php?a=French");
    print(json);

    return List<MealDto>.from(json['meals'].map<MealDto>((meal) => MealDto.fromJson(meal)));
  }
}
