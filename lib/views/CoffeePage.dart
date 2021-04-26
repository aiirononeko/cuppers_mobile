import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:intl/intl.dart';

// カッピング情報詳細画面
class CoffeePage extends StatefulWidget {

  // 引数にドキュメントIDを受け取る
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
          appBar: AppBar(
            title: Text(
              'Cuppers',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 25
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 5, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.ios_share),
                        onPressed: () {
                          // TODO ボタンを押下した際の処理を追加
                        },
                      ),
                    ),
                    Container(
                      child: IconButton(
                        icon: _getFavoriteFlag(snapshot.data['favorite']),
                        onPressed: () {
                          _switchFavoriteFlag(snapshot.data, widget.documentId, _uid);
                        }
                      )
                    ),
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.create_sharp),
                        onPressed: () {
                          // TODO ボタンを押下した際の処理を追加
                        },
                      )
                    )
                  ],
                )
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Divider(
                  color: Colors.black,
                ),
              ),
              Container(
                width: 375,
                height: 580,
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: HexColor('dcdcdc'),
                  boxShadow: [
                    BoxShadow(
                      color: HexColor('dcdcdc'),
                      spreadRadius: 1.0,
                      blurRadius: 10.0,
                      offset: Offset(5, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(30, 30, 0, 0),
                      child: Text(
                        cuppedDate,
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(30, 5, 0, 0),
                      child: Text(
                        '${snapshot.data['coffee_name']} ${snapshot.data['process']}',
                        style: TextStyle(
                            fontSize: 30
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(30, 5, 0, 0),
                      child: Text(
                        'Made in ${snapshot.data['country']}',
                        style: TextStyle(
                            fontSize: 20
                        ),
                      ),
                    ),
                    // 余白が作れないため、コンテナウィジェットで代用
                    Container(
                        height: 10
                    ),
                    Container(
                        width: 300,
                        height: 300,
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
                    Container(
                      // width: double.infinity,
                        margin: EdgeInsets.fromLTRB(220, 10, 0, 0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Score',
                                style: TextStyle(
                                    fontSize: 20
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                '${snapshot.data['coffee_score']}',
                                style: TextStyle(
                                    fontSize: 40
                                ),
                              ),
                            ),
                          ],
                        )
                    )
                  ],
                ),
              )
            ],
          )
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

// カラーコードで色を表示するためのクラス
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
