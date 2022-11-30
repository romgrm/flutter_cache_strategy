import 'package:example/data/datasource/fetch_data_impl.dart';
import 'package:example/data/domain/meal.entity.dart';

class DataRepository {
  final provider = FetchDataImpl();
  Future<List<MealEntity>> getData() async {
    final result = await provider.getData();
    if (result != null) {
      return List<MealEntity>.from(result.map((mealDto) => mealDto.toEntity()));
    }
    return [];
  }
}
