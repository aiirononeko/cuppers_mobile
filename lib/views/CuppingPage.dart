import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:async';

class CuppingPage extends StatefulWidget {

  @override
  _CuppingPageState createState() => _CuppingPageState();
}

// カッピング情報詳細画面
class _CuppingPageState extends State<CuppingPage> {

  // ログイン中のユーザー情報格納用変数
  String _uid = '';

  // 表示切り替え機能で使用する変数
  int _selectIndex = 0;

  // タイマー機能で使用する変数
  int _countMinute = 0;
  String _countMinuteStr = '00';
  int _countSecond = 0;
  String _countSecondStr = '00';
  Timer _timer;

  TextEditingController _coffeeNameController;
  TextEditingController _countryController;
  TextEditingController _processController;

  @override
  void initState() {
    super.initState();
    _coffeeNameController = new TextEditingController(text: _coffeeName);
    _countryController = new TextEditingController(text: _country);
    _processController = new TextEditingController(text: _process);
  }

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

  @override
  Widget build(BuildContext context) {

    // ログイン中のユーザーIDを取得
    _uid = FirebaseAuth.instance.currentUser.uid;

    // 表示項目の制御
    List<Widget> _pageList = [
      _coffeeInfoField(),
      _firstCuppingData(),
      _secondCuppingData()
    ];

    return Scaffold(
      body: Column(
        children: <Widget>[
          _pageList[_selectIndex],
          Row(
            children: <Widget>[
              IconButton(
                  icon: const Icon(Icons.navigate_before),
                  onPressed: () {
                    if(_selectIndex > 0) {
                      setState(() {
                        _selectIndex--;
                      });
                    }
                  }
              ),
              IconButton(
                  icon: const Icon(Icons.navigate_next),
                  onPressed: () {
                    if(_selectIndex < 2) {
                      setState(() {
                        _selectIndex++;
                      });
                    }
                  }
              ),
            ],
          ),
          Container(
            child: Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.stop),
                    onPressed: () {
                      _resetTimer();
                    }
                ),
                IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: () {
                      setState(() {
                        this._timer.cancel();
                      });
                    }
                ),
                Text(
                  '${this._countMinuteStr}:${this._countSecondStr}',
                  style: TextStyle(
                      fontSize: 50
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: () {
                    setState(() {
                      this._timer = Timer.periodic(Duration(seconds: 1), _onTimer);
                    });
                  }
                )
              ],
            )
          ),
          FlatButton(
            onPressed: () {
              _realTimeCuppingData = _setCuppingData();
              _writeCuppingData(_realTimeCuppingData, this._uid);

              // タイマーをストップする
              this._timer.cancel();

              // ユーザー画面へ遷移
              Navigator.of(context).pushReplacementNamed('/home');
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
      ),
    );
  }

  // コーヒー名などを入力する部分
  Widget _coffeeInfoField() {
    return Column(
        children: <Widget>[
          Text(
            'カッピング 1/3',
            style: TextStyle(
              fontSize: 20
            ),
          ),
          TextField(
            controller: _coffeeNameController,
            decoration: InputDecoration(
              labelText: 'Coffee Name',
              hintText: 'Yirgacheffe Konga',
            ),
            keyboardType: TextInputType.text,
            onChanged: _coffeeNameChanged,
          ),
          TextField(
            controller: _countryController,
            decoration: InputDecoration(
              labelText: 'Country',
              hintText: 'Ethiopia'
            ),
            keyboardType: TextInputType.text,
            onChanged: _countryChanged,
          ),
          TextField(
            controller: _processController,
            decoration: InputDecoration(
              labelText: 'Process',
              hintText: 'Full Washed'
            ),
            keyboardType: TextInputType.text,
            onChanged: _processChanged,
          )
        ]
    );
  }

  // カッピング項目入力画面1
  Widget _firstCuppingData() {
    return Column(
      children: <Widget>[
        Text(
          'カッピング 2/3',
          style: TextStyle(
              fontSize: 20
          ),
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
      ],
    );
  }

  // カッピング項目入力画面2
  Widget _secondCuppingData() {
    return Column(
      children: <Widget>[
        Text(
          'カッピング 3/3',
          style: TextStyle(
              fontSize: 20
          ),
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
      ],
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
  void _writeCuppingData(Map<String, dynamic> cuppingData, String uid) async {
    await FirebaseFirestore.instance
        .collection('CuppedCoffee')
        .doc(uid)
        .collection('CoffeeInfo')
        .add(cuppingData);
  }

  // タイマー
  void _onTimer(Timer timer) {
    if (_countSecond < 59) {
      setState(() {
        this._countSecond++;
      });

      if (this._countSecond <= 9) {
        setState(() {
          this._countSecondStr = '0${this._countSecond}';
        });
      } else {
        setState(() {
          this._countSecondStr = '${this._countSecond}';
        });
      }
    } else {
      setState(() {
        this._countSecond = 0;
        this._countSecondStr = '00';
        this._countMinute++;
      });

      if (this._countMinute <= 9) {
        setState(() {
          this._countMinuteStr = '0${this._countMinute}';
        });
      } else {
        setState(() {
          this._countMinuteStr = '${this._countMinute}';
        });
      }
    }
  }

  // タイマーをリセットするメソッド
  void _resetTimer() {
    setState(() {
      this._countMinute = 0;
      this._countSecond = 0;
      this._countSecondStr = '00';
    });
  }
}
