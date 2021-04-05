import 'package:flutter/material.dart';
import 'dart:developer' as developer;

// カッピング情報詳細画面
class CoffeePage extends StatelessWidget {

  final Map<String, dynamic> coffeeInfo;

  CoffeePage({Key key, @required this.coffeeInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cuppers")),
      body: Center(
        child: Text(coffeeInfo.toString())
      ),
    );
  }
}
