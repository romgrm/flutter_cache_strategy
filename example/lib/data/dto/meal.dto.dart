import 'package:example/data/domain/meal.entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meal.dto.g.dart';

@JsonSerializable(explicitToJson: true)
class MealDto {
  String? idMeal;
  String? strMeal;
  String? strMealThumb;
  MealDto({
    this.idMeal,
    this.strMeal,
    this.strMealThumb,
  });

  factory MealDto.fromJson(Map<String, dynamic> json) => _$MealDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MealDtoToJson(this);

  MealEntity toEntity() => MealEntity(idMeal: idMeal ?? "", strMeal: strMeal ?? "", strMealThumb: strMealThumb ?? "");
}
