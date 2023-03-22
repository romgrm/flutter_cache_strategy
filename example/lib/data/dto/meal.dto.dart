import 'package:example/data/domain/meal.entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meal.dto.g.dart';

@JsonSerializable(explicitToJson: true)
class MealDto {
  String? idMeal;
  String? strMeal;
  String? strMealThumb;
  String? strFlag;
  MealDto({this.idMeal, this.strMeal, this.strMealThumb, this.strFlag});

  static List<MealDto> fromData(dynamic json) => List<MealDto>.from(json?.map<MealDto>((json) => MealDto.fromJson(json)));

  factory MealDto.fromJson(Map<String, dynamic> json) => _$MealDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MealDtoToJson(this);

  MealEntity toEntity() => MealEntity(idMeal: idMeal ?? "", strMeal: strMeal ?? "", strMealThumb: strMealThumb ?? "", strFlag: strFlag ?? "");
}
