import 'package:example/data/dto/meal.dto.dart';

abstract class FetchData {
  Future<List<MealDto>?> getFrenchFood();
  Future<List<MealDto>?> getEnglishFood();
}
