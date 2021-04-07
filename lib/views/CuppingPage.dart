import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import './CoffeePage.dart';

// カッピング情報詳細画面
class CuppingPage extends StatelessWidget {

  final Map<String, dynamic> _realTimeCuppingData = new Map<String, dynamic>();

  // TODO ダミーデータ
  Map<String, dynamic> _dummyCuppingData = {
    "coffee_name": "イルガチェフ",
    "country": "エチオピア",
    "process": "フルウォッシュト",
    "sweetness": 8,
    "acidity": 8,
    "mousefeel": 8,
    "aftertaste": 8,
    "cleancup": 8,
    "balance": 8,
    "flavor": 8,
    "overall": 8,
    "coffee_score": 85,
    "favorite": false,
    "cupped_date": Timestamp.fromDate(DateTime.now())
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: const Text('テストデータ投入'),
          color: Colors.blue,
          textColor: Colors.white,
          onPressed: () {
            _setCuppingData(_dummyCuppingData); // TODO ダミー
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CoffeePage(coffeeInfo: _dummyCuppingData) // TODO ダミー
                )
            );
          },
        ),
      )
    );
  }

  // Firestoreにデータを登録するメソッド
  void _setCuppingData(Map<String, dynamic> cuppingData) async {
    await FirebaseFirestore.instance
        .collection('CuppedCoffee')
        .doc('VjiipudVwojp7B1WWrWH') // TODO 変数を利用する形に変更
        .collection('CoffeeInfo')
        .add(cuppingData);
  }
}
