import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:intl/intl.dart';

// カッピング情報詳細画面
class CoffeePage extends StatefulWidget {

  final String documentId;
  CoffeePage(this.documentId);

  @override
  _CoffeePageState createState() => _CoffeePageState();
}

class _CoffeePageState extends State<CoffeePage> {

  final List<List<int>> chartValueList = [];

  @override
  Widget build(BuildContext context) {

    // ログイン中のユーザーIDを取得
    String _uid = FirebaseAuth.instance.currentUser.uid;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('CuppedCoffee')
          .doc(_uid)
          .collection('CoffeeInfo')
          .doc(widget.documentId)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (!snapshot.hasData) {
          print('loading...');
        }

        // スコアの値をレイダーチャートに表示するためのリストに詰め替える
        chartValueList.add(getListValue(snapshot.data));

        // カッピングした日付をフォーマット
        String cuppedDate = DateFormat('yyyy-MM-dd').format(snapshot.data['cupped_date'].toDate()).toString();

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
                          '${snapshot.data['coffee_name']} ${snapshot.data['process']}',
                          style: TextStyle(
                              fontSize: 30
                          ),
                        ),
                        Text(
                          'Made in ${snapshot.data['country']}',
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
                        'Score ${snapshot.data['coffee_score']}',
                        style: TextStyle(
                            fontSize: 30
                        ),
                      ),
                      IconButton(
                          icon: _getFavoriteFlag(snapshot.data['favorite']),
                          onPressed: () {
                            _switchFavoriteFlag(snapshot.data, widget.documentId, _uid);
                          }
                      )
                    ],
                  )
              ),
            ],
          ),
        );
      },
    );
  }

  // TODO double型に対応していないため、int型に変換してしまっている
  // レイダーチャートに表示する型に詰め替えるメソッド
  List<int> getListValue(DocumentSnapshot coffeeInfo) {

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
  void _switchFavoriteFlag(DocumentSnapshot data, String documentId, String uid) {

    if (data['favorite']) {
      FirebaseFirestore.instance
          .collection('CuppedCoffee')
          .doc(uid)
          .collection('CoffeeInfo')
          .doc(documentId)
          .update({'favorite': false});
    } else {
      FirebaseFirestore.instance
          .collection('CuppedCoffee')
          .doc(uid)
          .collection('CoffeeInfo')
          .doc(documentId)
          .update({'favorite': true});
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
