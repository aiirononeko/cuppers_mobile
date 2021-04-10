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

    // スコアの値をレイダーチャートに表示するためのリストに詰め替える
    chartValueList.add(getListValue(coffeeInfo));

    return Scaffold(
      appBar: AppBar(title: Text("Cuppers")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      coffeeInfo['cupped_date'].toDate().toString(),
                      style: TextStyle(
                        fontSize: 16
                      ),
                    ),
                    Text(
                      '${coffeeInfo['coffee_name']} ${coffeeInfo['process']}',
                      style: TextStyle(
                        fontSize: 30
                      ),
                    ),
                    Text(
                      'Made in ${coffeeInfo['country']}',
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                  ],
                ),
              )
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Container(
                    child: RadarChart.light(
                      ticks: [2, 4, 6, 8],
                      features: [
                        "CleanCup",
                        "Sweetness",
                        "Acidity",
                        "MouseFeel",
                        "Flavor",
                        "AfterTaste",
                        "Balance",
                        "OverAll"
                      ],
                      data: chartValueList,
                    ),
                  )
                )
              )
            ),
            Expanded(
              child: Text(
                'Score ${coffeeInfo['coffee_score']}',
                style: TextStyle(
                  fontSize: 30
                ),
              )
            )
          ],
        ),
    );
  }

  // レイダーチャートに表示する型に詰め替えるメソッド
  // TODO double型に対応していないため、int型に変換してしまっている
  List<int> getListValue(final Map<String, dynamic> coffeeInfo) {

    List<int> valueList = [];
    valueList.add(coffeeInfo['cleancup'].toInt());
    valueList.add(coffeeInfo['sweetness'].toInt());
    valueList.add(coffeeInfo['acidity'].toInt());
    valueList.add(coffeeInfo['mousefeel'].toInt());
    valueList.add(coffeeInfo['flavor'].toInt());
    valueList.add(coffeeInfo['aftertaste'].toInt());
    valueList.add(coffeeInfo['balance'].toInt());
    valueList.add(coffeeInfo['overall'].toInt());

    return valueList;
  }
}
