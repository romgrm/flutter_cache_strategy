import 'package:example/data/domain/meal.entity.dart';
import 'package:example/data/repositories/european_food.repository.dart';
import 'package:example/data/repositories/indian_food.repository.dart';
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
  final indianRepo = IndianFoodRepository();
  final europeanRepo = EuropeanFoodRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Row(
      children: [
        Expanded(
            child: FutureBuilder(
                future: indianRepo.getIndianFood(),
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
                future: europeanRepo.getEuropeanFood(),
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
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
                onPressed: () {
                  europeanRepo.clear(keyCache: "frenchFood");
                  setState(() {});
                },
                child: const Text("clean just french food")),
            OutlinedButton(
                onPressed: () {
                  europeanRepo.clear(keyCache: "italianFood");
                  setState(() {});
                },
                child: const Text("clean just italian food")),
            OutlinedButton(
                onPressed: () {
                  europeanRepo.clear();
                  setState(() {});
                },
                child: const Text("clean just BOXE 1")),
          ],
        ),
      ],
    )));
  }
}
