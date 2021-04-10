import 'package:flutter/material.dart';

import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'dart:developer' as developer;

// カッピング情報詳細画面
class CoffeePage extends StatelessWidget {

  final Map<String, dynamic> coffeeInfo;
  final List<List<int>> chartValueList = [];

  CoffeePage({Key key, @required this.coffeeInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cuppers")),
      body: RadarChart.light(
          ticks: [2, 4, 6, 8],
          features: [
            "cleancup",
            "sweetness",
            "acidity",
            "mousefeel",
            "flavor",
            "aftertaste",
            "balance",
            "overall"
          ],
          data: chartValueList
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: <Widget>[
      //       Text(coffeeInfo['cupped_date'].toDate().toString()),
      //       Text('${coffeeInfo['coffee_name']} ${coffeeInfo['process']}'),
      //       Text('Made in ${coffeeInfo['country']}'),
      //       Text('Score ${coffeeInfo['coffee_score']}'),
      //       Text('Sweetness ${coffeeInfo['sweetness']}'),
      //       Text('cleancup ${coffeeInfo['cleancup']}'),
      //       Text('mousefeel ${coffeeInfo['mousefeel']}'),
      //       Text('flavor ${coffeeInfo['flavor']}'),
      //       Text('aftertaste ${coffeeInfo['aftertaste']}'),
      //       Text('balance ${coffeeInfo['balance']}'),
      //       Text('overall ${coffeeInfo['overall']}'),
      //     ],
      //   ),
      // )
    );
  }
}
