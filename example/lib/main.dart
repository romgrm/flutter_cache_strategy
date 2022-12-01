import 'package:example/data/domain/meal.entity.dart';
import 'package:example/data/repositories/data.repository.dart';
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
  String test = "";
  final repo = DataRepository();
  List<MealEntity> meals = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
                child: FutureBuilder(
                    future: repo.getData(),
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
                    })))));
  }
}
