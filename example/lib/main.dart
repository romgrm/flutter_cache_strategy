import 'package:flutter/material.dart';
import 'package:flutter_cache_strategy/cache_strategy.dart';

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
  void tryFetchText() {
    CacheStrategy().defaultSessionName = "hey";
    print(CacheStrategy().defaultSessionName);
    test = CacheStrategy().defaultSessionName ?? "";
  }

  @override
  void initState() {
    super.initState();
    tryFetchText();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
      child: Text(
        test,
        style: TextStyle(color: Colors.red),
      ),
    )));
  }
}
