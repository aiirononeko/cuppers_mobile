import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import './CoffeePage.dart';

class CuppingPage extends StatefulWidget {

  @override
  _CuppingPageState createState() => _CuppingPageState();
}

// カッピング情報詳細画面
class _CuppingPageState extends State<CuppingPage> {

  // データ書き込み処理時に使用するMap型State
  Map<String, dynamic> _realTimeCuppingData = new Map<String, dynamic>();

  // カッピング項目のState
  String _coffeeName = '';
  String _country = '';
  String _process = '';
  double _sweetness = 4.0;
  double _acidity = 4.0;
  double _cleanCup = 4.0;
  double _mouseFeel = 4.0;
  double _afterTaste = 4.0;
  double _balance = 4.0;
  double _flavor = 4.0;
  double _overall = 4.0;
  double _coffeeScore = 0;

  void _coffeeNameChanged(String str) => setState(() {_coffeeName = str; });
  void _countryChanged(String str) => setState(() {_country = str; });
  void _processChanged(String str) => setState(() {_process = str; });
  void _slideSweetness(double e) => setState(() { _sweetness = e; });
  void _slideAcidity(double e) => setState(() {_acidity = e; });
  void _slideCleanCup(double e) => setState(() {_cleanCup = e; });
  void _slideMouseFeel(double e) => setState(() {_mouseFeel = e; });
  void _slideAfterTaste(double e) => setState(() {_afterTaste = e; });
  void _slideBalance(double e) => setState(() {_balance = e; });
  void _slideFlavor(double e) => setState(() {_flavor = e; });
  void _slideOverall(double e) => setState(() {_overall = e; });

  // TODO ダミーデータ
  final Map<String, dynamic> _dummyCuppingData = {
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
      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                    labelText: 'Coffee Name',
                    hintText: 'Yirgacheffe Konga'
                ),
                keyboardType: TextInputType.text,
                onChanged: _coffeeNameChanged,
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Country',
                    hintText: 'Ethiopia'
                ),
                keyboardType: TextInputType.text,
                onChanged: _countryChanged,
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Process',
                    hintText: 'Full Washed'
                ),
                keyboardType: TextInputType.text,
                onChanged: _processChanged,
              ),
              Text('クリーンカップ'),
              new Slider(
                  label: '$_cleanCup',
                  min: 0,
                  max: 8,
                  value: _cleanCup,
                  // activeColor: Colors.orange,
                  // inactiveColor: Colors.blue,
                  divisions: 16,
                  onChanged: _slideCleanCup
              ),
              Text('甘さ'),
              new Slider(
                  label: '$_sweetness',
                  min: 0,
                  max: 8,
                  value: _sweetness,
                  // activeColor: Colors.orange,
                  // inactiveColor: Colors.blue,
                  divisions: 16,
                  onChanged: _slideSweetness
              ),
              Text('酸'),
              new Slider(
                  label: '$_acidity',
                  min: 0,
                  max: 8,
                  value: _acidity,
                  // activeColor: Colors.orange,
                  // inactiveColor: Colors.blue,
                  divisions: 16,
                  onChanged: _slideAcidity
              ),
              Text('マウスフィール'),
              new Slider(
                  label: '$_mouseFeel',
                  min: 0,
                  max: 8,
                  value: _mouseFeel,
                  // activeColor: Colors.orange,
                  // inactiveColor: Colors.blue,
                  divisions: 16,
                  onChanged: _slideMouseFeel
              ),
              Text('アフターテイスト'),
              new Slider(
                  label: '$_afterTaste',
                  min: 0,
                  max: 8,
                  value: _afterTaste,
                  // activeColor: Colors.orange,
                  // inactiveColor: Colors.blue,
                  divisions: 16,
                  onChanged: _slideAfterTaste
              ),
              Text('フレーバー'),
              new Slider(
                  label: '$_flavor',
                  min: 0,
                  max: 8,
                  value: _flavor,
                  // activeColor: Colors.orange,
                  // inactiveColor: Colors.blue,
                  divisions: 16,
                  onChanged: _slideFlavor
              ),
              Text('バランス'),
              new Slider(
                  label: '$_balance',
                  min: 0,
                  max: 8,
                  value: _balance,
                  // activeColor: Colors.orange,
                  // inactiveColor: Colors.blue,
                  divisions: 16,
                  onChanged: _slideBalance
              ),
              Text('オーバーオール'),
              new Slider(
                  label: '$_overall',
                  min: 0,
                  max: 8,
                  value: _overall,
                  // activeColor: Colors.orange,
                  // inactiveColor: Colors.blue,
                  divisions: 16,
                  onChanged: _slideOverall
              ),
              FlatButton(
                onPressed: () {
                  _realTimeCuppingData = _setCuppingData();
                  _writeCuppingData(_realTimeCuppingData);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CoffeePage(coffeeInfo: _realTimeCuppingData)
                      )
                  );
                },
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                ),
                child: Text(
                  'カッピングデータを保存',
                  style: TextStyle(
                      color:Colors.white,
                      fontSize: 20.0
                  ),
                ),
              )
            ],
            // child: RaisedButton(
            //   child: const Text('テストデータ投入'),
            //   color: Colors.blue,
            //   textColor: Colors.white,
            //   onPressed: () {
            //     _setCuppingData(_dummyCuppingData); // TODO ダミー
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => CoffeePage(coffeeInfo: _dummyCuppingData) // TODO ダミー
            //         )
            //     );
            //   },
            // ),
          )
      )
    );
  }

  // カッピングしたデータをMap型に詰め直すメソッド
  Map<String, dynamic> _setCuppingData() {
    Map<String, dynamic> cuppingData = new Map<String, dynamic>();

    cuppingData["coffee_name"] = _coffeeName;
    cuppingData["country"] = _country;
    cuppingData["process"] = _process;
    cuppingData["sweetness"] = _sweetness;
    cuppingData["acidity"] = _acidity;
    cuppingData["mousefeel"] = _mouseFeel;
    cuppingData["aftertaste"] = _afterTaste;
    cuppingData["cleancup"] = _cleanCup;
    cuppingData["balance"] = _balance;
    cuppingData["flavor"] = _flavor;
    cuppingData["overall"] = _overall;
    cuppingData["coffee_score"] = _coffeeScore;
    cuppingData["favorite"] = false;
    cuppingData["cupped_date"] = Timestamp.fromDate(DateTime.now());

    cuppingData['coffee_score'] =
      _cleanCup + _sweetness + _acidity + _mouseFeel + _afterTaste +
      _balance + _flavor + _overall + 36;
    return cuppingData;
  }

  // Firestoreにデータを登録するメソッド
  void _writeCuppingData(Map<String, dynamic> cuppingData) async {
    await FirebaseFirestore.instance
        .collection('CuppedCoffee')
        .doc('VjiipudVwojp7B1WWrWH') // TODO 変数を利用する形に変更
        .collection('CoffeeInfo')
        .add(cuppingData);
  }
}
