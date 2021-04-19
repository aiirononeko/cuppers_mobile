import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:intl/intl.dart';

// カッピング情報詳細画面
class CoffeePage extends StatefulWidget {

  final Map<String, dynamic> coffeeInfo;
  CoffeePage(this.coffeeInfo);

  @override
  _CoffeePageState createState() => _CoffeePageState();
}

class _CoffeePageState extends State<CoffeePage> {

  final List<List<int>> chartValueList = [];

  bool _favoriteFlag;

  @override
  Widget build(BuildContext context) {

    // ログイン中のユーザーIDを取得
    String _uid = FirebaseAuth.instance.currentUser.uid;

    // スコアの値をレイダーチャートに表示するためのリストに詰め替える
    chartValueList.add(getListValue(widget.coffeeInfo));

    // お気に入りフラグの値をセット
    _favoriteFlag = widget.coffeeInfo['favorite'];

    // カッピングした日付をフォーマット
    String cuppedDate = DateFormat('yyyy-MM-dd').format(widget.coffeeInfo['cupped_date'].toDate()).toString();

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
                      cuppedDate,
                      style: TextStyle(
                        fontSize: 16
                      ),
                    ),
                    Text(
                      '${widget.coffeeInfo['coffee_name']} ${widget.coffeeInfo['process']}',
                      style: TextStyle(
                        fontSize: 30
                      ),
                    ),
                    Text(
                      'Made in ${widget.coffeeInfo['country']}',
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
              child: Row(
                children: <Widget>[
                  Text(
                    'Score ${widget.coffeeInfo['coffee_score']}',
                    style: TextStyle(
                        fontSize: 30
                    ),
                  ),
                  IconButton(
                    icon: _getFavoriteFlag(this._favoriteFlag),
                    onPressed: () {
                      _switchFavoriteFlag(widget.coffeeInfo, _uid);
                    }
                  )
                ],
              )
            ),
          ],
        ),
    );
  }

  // TODO double型に対応していないため、int型に変換してしまっている
  // レイダーチャートに表示する型に詰め替えるメソッド
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

  // お気に入りフラグを更新するメソッド
  void _switchFavoriteFlag(Map<String, dynamic> data, String uid) {

    if (data['favorite']) {
      FirebaseFirestore.instance
          .collection('CuppedCoffee')
          .doc(uid)
          .collection('CoffeeInfo')
          .doc(data['documentId'])
          .update({'favorite': false});
      setState(() {
        this._favoriteFlag = false;
      });
    } else {
      FirebaseFirestore.instance
          .collection('CuppedCoffee')
          .doc(uid)
          .collection('CoffeeInfo')
          .doc(data['documentId'])
          .update({'favorite': true});
      setState(() {
        this._favoriteFlag = true;
      });
    }
  }

  // お気に入りか否かを判定してアイコンを返却するメソッド
  Icon _getFavoriteFlag(bool flag) {

    if (flag) {
      return Icon(Icons.star);
    } else {
      return Icon(Icons.star_border);
    }
  }
}
