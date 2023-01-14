import 'package:example/data/domain/meal.entity.dart';
import 'package:example/data/repositories/english_food.repository.dart';
import 'package:example/data/repositories/french_food.repository.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CacheStrategyExample());
}

class CacheStrategyExample extends StatefulWidget {
  const CacheStrategyExample({Key? key}) : super(key: key);

  @override
  State<CacheStrategyExample> createState() => _CacheStrategyExampleState();
}

class _CacheStrategyExampleState extends State<CacheStrategyExample> {
  final frenchRepo = FrenchFoodRepository();
  final englishRepo = EnglishFoodRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Row(
      children: [
        Expanded(
            child: FutureBuilder(
                future: frenchRepo.getData(),
                builder: ((context, AsyncSnapshot<List<MealEntity>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: ((context, index) {
                          return Text(snapshot.data![index].strMeal);
                        }));
                  } else {
                    return const CircularProgressIndicator();
                  }
                }))),
        Expanded(
            child: FutureBuilder(
                future: englishRepo.getEnglishFood(),
                builder: ((context, AsyncSnapshot<List<MealEntity>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: ((context, index) {
                          return Text(snapshot.data![index].strMeal);
                        }));
                  } else {
                    return const CircularProgressIndicator();
                  }
                }))),
      ],
    )));
  }
}
