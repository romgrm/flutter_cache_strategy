import 'package:cached_network_image/cached_network_image.dart';
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
            body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: FutureBuilder(
                          future: indianRepo.getIndianFood(),
                          builder: ((context, AsyncSnapshot<List<MealEntity>> snapshot) {
                            if (snapshot.hasError) {
                              return const Center(child: Text("An error appears"));
                            } else if (snapshot.hasData) {
                              return RefreshIndicator(
                                onRefresh: () => indianRepo.getIndianFood(),
                                child: ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: ((context, index) {
                                      return mealCard(snapshot.data![index].strMeal, snapshot.data![index].strMealThumb, snapshot.data![index].strFlag);
                                    })),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          }))),
                  Expanded(
                      child: FutureBuilder(
                          future: europeanRepo.getEuropeanFood(),
                          builder: ((context, AsyncSnapshot<List<MealEntity>> snapshot) {
                            if (snapshot.hasError) {
                              return const Center(child: Text("An error appears"));
                            } else if (snapshot.hasData) {
                              return RefreshIndicator(
                                onRefresh: () => europeanRepo.getEuropeanFood(),
                                child: ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: ((context, index) {
                                      return mealCard(snapshot.data![index].strMeal, snapshot.data![index].strMealThumb, snapshot.data![index].strFlag);
                                    })),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          }))),
                ],
              ),
            ),
            Flexible(
              flex: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        europeanRepo.clear(keyCache: "frenchFood");
                        setState(() {});
                      },
                      child: const Text("Remove French food from cache")),
                  OutlinedButton(
                      onPressed: () {
                        europeanRepo.clear(keyCache: "italianFood");
                        setState(() {});
                      },
                      child: const Text("Remove Italian food from cache")),
                  OutlinedButton(
                      onPressed: () {
                        europeanRepo.clear();
                        setState(() {});
                      },
                      child: const Text("Remove European food from cache")),
                ],
              ),
            ),
          ],
        ),
      ),
    )));
  }

  Widget mealCard(String title, String thumb, String icon) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        margin: const EdgeInsets.all(5),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: thumb,
            ),
            ListTile(
              title: Text(
                title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              leading: Image.asset(
                icon,
                width: 20,
              ),
            ),
          ],
        ));
  }
}
