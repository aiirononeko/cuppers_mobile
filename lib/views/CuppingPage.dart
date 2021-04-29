import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuppers_mobile/main.dart';
import 'package:cuppers_mobile/views/CoffeeIndexPage.dart';
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

  // カッピングページ表示切り替え機能で使用する変数
  int _selectIndex = 0;

  // カッピングコーヒー切り替え機能で使用する変数
  int _selectCoffeeIndex = 0;

  // タイマー機能で使用する変数
  int _countMinute = 0;
  String _countMinuteStr = '00';
  int _countSecond = 0;
  String _countSecondStr = '00';
  Timer _timer;

  TextEditingController _coffeeNameController;
  TextEditingController _countryController;
  TextEditingController _processController;

  TextEditingController _coffeeNameControllerSecond;
  TextEditingController _countryControllerSecond;
  TextEditingController _processControllerSecond;

  @override
  void initState() {
    super.initState();
    _coffeeNameController = new TextEditingController(text: _coffeeName);
    _countryController = new TextEditingController(text: _country);
    _processController = new TextEditingController(text: _process);

    _coffeeNameControllerSecond = new TextEditingController(text: _coffeeNameSecond);
    _countryControllerSecond = new TextEditingController(text: _countrySecond);
    _processControllerSecond = new TextEditingController(text: _processSecond);
  }

  // データ書き込み処理時に使用するMap型State
  Map<String, dynamic> _realTimeCuppingData = new Map<String, dynamic>();
  Map<String, dynamic> _realTimeCuppingDataSecond = new Map<String, dynamic>();

  // カッピング項目のState_1
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

  // カッピング項目のState_2
  String _coffeeNameSecond = '';
  String _countrySecond = '';
  String _processSecond = '';
  double _sweetnessSecond = 4.0;
  double _aciditySecond = 4.0;
  double _cleanCupSecond = 4.0;
  double _mouseFeelSecond = 4.0;
  double _afterTasteSecond = 4.0;
  double _balanceSecond = 4.0;
  double _flavorSecond = 4.0;
  double _overallSecond = 4.0;

  void _coffeeNameSecondChanged(String str) => setState(() {_coffeeNameSecond = str; });
  void _countrySecondChanged(String str) => setState(() {_countrySecond = str; });
  void _processSecondChanged(String str) => setState(() {_processSecond = str; });
  void _slideSweetnessSecond(double e) => setState(() { _sweetnessSecond = e; });
  void _slideAciditySecond(double e) => setState(() {_aciditySecond = e; });
  void _slideCleanCupSecond(double e) => setState(() {_cleanCupSecond = e; });
  void _slideMouseFeelSecond(double e) => setState(() {_mouseFeelSecond = e; });
  void _slideAfterTasteSecond(double e) => setState(() {_afterTasteSecond = e; });
  void _slideBalanceSecond(double e) => setState(() {_balanceSecond = e; });
  void _slideFlavorSecond(double e) => setState(() {_flavorSecond = e; });
  void _slideOverallSecond(double e) => setState(() {_overallSecond = e; });

  @override
  Widget build(BuildContext context) {

    // ログイン中のユーザーIDを取得
    _uid = FirebaseAuth.instance.currentUser.uid;

    // カッピングページ表示項目の制御
    List<Widget> _pageList = [
      _coffeeInfoField(), // 0
      _firstCuppingData(), // 1
      _secondCuppingData(), // 2
      _coffeeInfoFieldSecond(), // 3
      _firstCuppingDataSecond(), // 4
      _secondCuppingDataSecond(), // 5
    ];

    // カッピングコーヒーの制御
    List<Widget> _coffeeIndex = [
      _buttonOneAble(),
      _buttonTwoAble(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: HexColor('313131'),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: new IconButton(
          icon: new Icon(Icons.close, color: Colors.white),
          onPressed: () {
            if (this._timer != null) {
              // タイマーをストップする
              this._timer.cancel();
            }
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: HexColor('313131'),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                color: HexColor('e7e7e7'),
              ),
              child: Column(
                children: <Widget>[
                  _pageList[_selectIndex],
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                            icon: const Icon(Icons.navigate_before),
                            onPressed: _selectIndex == 0 || _selectIndex == 3 ? null : () {
                              if(_selectIndex > 0) {
                                setState(() {
                                  _selectIndex--;
                                });
                              }
                            }
                        ),
                        IconButton(
                            icon: const Icon(Icons.navigate_next),
                            onPressed: _selectIndex == 2 || _selectIndex == 5 ? null: () {
                              if(_selectIndex < 5) {
                                setState(() {
                                  _selectIndex++;
                                });
                              }
                            }
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            _coffeeIndex[_selectCoffeeIndex], // カッピングするコーヒーを切り替え
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.stop, color: HexColor('e7e7e7')),
                    onPressed: () {
                      _resetTimer();
                    }
                  ),
                  IconButton(
                    icon: Icon(Icons.pause, color: HexColor('e7e7e7')),
                    onPressed: () {
                      setState(() {
                        this._timer.cancel();
                      });
                    }
                  ),
                  Text(
                    '${this._countMinuteStr}:${this._countSecondStr}',
                    style: TextStyle(
                      fontSize: 60,
                      color: HexColor('e7e7e7')
                    ),
                  ),
                  Container(
                    width: 20,
                  ),
                  IconButton(
                    icon: Icon(Icons.play_arrow, color: HexColor('e7e7e7')),
                    onPressed: () {
                      setState(() {
                        this._timer = Timer.periodic(Duration(seconds: 1), _onTimer);
                      });
                    }
                  )
                ],
              )
            ),
          ],
        )
      )
    );
  }

  // コーヒー名などを入力する部分
  Widget _coffeeInfoField() {
    return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Text(
              'カッピング 1/3',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Text(
              '各項目を評価してください',
              style: TextStyle(
                fontSize: 12
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(50, 79, 50, 0),
            child: TextField(
              controller: _coffeeNameController,
              decoration: InputDecoration(
                labelText: 'Coffee Name',
                hintText: 'Yirgacheffe Konga',
              ),
              keyboardType: TextInputType.text,
              onChanged: _coffeeNameChanged,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(50, 10, 50, 0),
            child: TextField(
              controller: _countryController,
              decoration: InputDecoration(
                  labelText: 'Country',
                  hintText: 'Ethiopia'
              ),
              keyboardType: TextInputType.text,
              onChanged: _countryChanged,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(50, 10, 50, 50),
            child: TextField(
              controller: _processController,
              decoration: InputDecoration(
                  labelText: 'Process',
                  hintText: 'Full Washed'
              ),
              keyboardType: TextInputType.text,
              onChanged: _processChanged,
            ),
          ),
        ]
    );
  }

  // カッピング項目入力画面1
  Widget _firstCuppingData() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Text(
            'カッピング 2/3',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: 12
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(50, 50, 50, 0),
          child: Column(
            children: <Widget>[
              Text('クリーンカップ'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('313131'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                  label: '$_cleanCup',
                  min: 0,
                  max: 8,
                  value: _cleanCup,
                  // activeColor: Colors.orange,
                  // inactiveColor: Colors.blue,
                  divisions: 16,
                  onChanged: _slideCleanCup
                ),
              )
            ],
          )
        ),
        Container(
          margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Column(
            children: <Widget>[
              Text('甘さ'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('313131'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                  label: '$_sweetness',
                  min: 0,
                  max: 8,
                  value: _sweetness,
                  // activeColor: Colors.orange,
                  // inactiveColor: Colors.blue,
                  divisions: 16,
                  onChanged: _slideSweetness
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Column(
            children: <Widget>[
              Text('酸'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('313131'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                  label: '$_acidity',
                  min: 0,
                  max: 8,
                  value: _acidity,
                  // activeColor: Colors.orange,
                  // inactiveColor: Colors.blue,
                  divisions: 16,
                  onChanged: _slideAcidity
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(50, 0, 50, 4),
          child: Column(
            children: <Widget>[
              Text('マウスフィール'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('313131'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                  label: '$_mouseFeel',
                  min: 0,
                  max: 8,
                  value: _mouseFeel,
                  // activeColor: Colors.orange,
                  // inactiveColor: Colors.blue,
                  divisions: 16,
                  onChanged: _slideMouseFeel
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // カッピング項目入力画面2
  Widget _secondCuppingData() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Text(
            'カッピング 3/3',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: 12
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(50, 50, 50, 0),
          child: Column(
            children: <Widget>[
              Text('アフターテイスト'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('313131'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                  label: '$_afterTaste',
                  min: 0,
                  max: 8,
                  value: _afterTaste,
                  // activeColor: Colors.orange,
                  // inactiveColor: Colors.blue,
                  divisions: 16,
                  onChanged: _slideAfterTaste
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Column(
            children: <Widget>[
              Text('フレーバー'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('313131'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                  label: '$_flavor',
                  min: 0,
                  max: 8,
                  value: _flavor,
                  // activeColor: Colors.orange,
                  // inactiveColor: Colors.blue,
                  divisions: 16,
                  onChanged: _slideFlavor
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Column(
            children: <Widget>[
              Text('バランス'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('313131'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                  label: '$_balance',
                  min: 0,
                  max: 8,
                  value: _balance,
                  // activeColor: Colors.orange,
                  // inactiveColor: Colors.blue,
                  divisions: 16,
                  onChanged: _slideBalance
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(50, 0, 50, 4),
          child: Column(
            children: <Widget>[
              Text('オーバーオール'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('313131'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                  label: '$_overall',
                  min: 0,
                  max: 8,
                  value: _overall,
                  // activeColor: Colors.orange,
                  // inactiveColor: Colors.blue,
                  divisions: 16,
                  onChanged: _slideOverall
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // カッピング項目入力画面3
  Widget _thirdCuppingData() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Text(
            'カッピング 4/4',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: 12
            ),
          ),
        ),
        Container(
          height: 50,
          margin: EdgeInsets.fromLTRB(0, 170, 0, 106),
          child: ElevatedButton(
            onPressed: () {
              _realTimeCuppingData = _setCuppingData();
              _writeCuppingData(_realTimeCuppingData, this._uid);

              if (this._timer != null) {
                // タイマーをストップする
                this._timer.cancel();
              }

              // ユーザー画面へ遷移
              Navigator.of(context).pushReplacementNamed('/home');
            },
            style: ElevatedButton.styleFrom(
              primary: HexColor('313131'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)
              ),
            ),
            child: Text(
              'カッピングデータを保存',
              style: TextStyle(
                  color:Colors.white,
                  fontSize: 20.0
              ),
            ),
          ),
        )
      ],
    );
  }

  // コーヒー名などを入力する部分2
  Widget _coffeeInfoFieldSecond() {
    return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Text(
              'カッピング 1/3',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Text(
              '各項目を評価してください',
              style: TextStyle(
                  fontSize: 12
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(50, 79, 50, 0),
            child: TextField(
              controller: _coffeeNameControllerSecond,
              decoration: InputDecoration(
                labelText: 'Coffee Name',
                hintText: 'Yirgacheffe Konga',
              ),
              keyboardType: TextInputType.text,
              onChanged: _coffeeNameSecondChanged,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(50, 10, 50, 0),
            child: TextField(
              controller: _countryControllerSecond,
              decoration: InputDecoration(
                  labelText: 'Country',
                  hintText: 'Ethiopia'
              ),
              keyboardType: TextInputType.text,
              onChanged: _countrySecondChanged,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(50, 10, 50, 50),
            child: TextField(
              controller: _processControllerSecond,
              decoration: InputDecoration(
                  labelText: 'Process',
                  hintText: 'Full Washed'
              ),
              keyboardType: TextInputType.text,
              onChanged: _processSecondChanged,
            ),
          ),
        ]
    );
  }

  // カッピング項目入力画面2_1
  Widget _firstCuppingDataSecond() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Text(
            'カッピング 2/3',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: 12
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.fromLTRB(50, 50, 50, 0),
            child: Column(
              children: <Widget>[
                Text('クリーンカップ'),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 10,
                    thumbColor: HexColor('313131'),
                    overlayColor: HexColor('808080').withAlpha(80),
                    activeTrackColor: HexColor('313131'),
                    inactiveTrackColor: HexColor('cccccc'),
                    inactiveTickMarkColor: HexColor('313131'),
                    activeTickMarkColor: HexColor('313131'),
                  ),
                  child: Slider(
                      label: '$_cleanCupSecond',
                      min: 0,
                      max: 8,
                      value: _cleanCupSecond,
                      // activeColor: Colors.orange,
                      // inactiveColor: Colors.blue,
                      divisions: 16,
                      onChanged: _slideCleanCupSecond
                  ),
                )
              ],
            )
        ),
        Container(
          margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Column(
            children: <Widget>[
              Text('甘さ'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('313131'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_sweetnessSecond',
                    min: 0,
                    max: 8,
                    value: _sweetnessSecond,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideSweetnessSecond
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Column(
            children: <Widget>[
              Text('酸'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('313131'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_aciditySecond',
                    min: 0,
                    max: 8,
                    value: _aciditySecond,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideAciditySecond
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(50, 0, 50, 4),
          child: Column(
            children: <Widget>[
              Text('マウスフィール'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('313131'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_mouseFeelSecond',
                    min: 0,
                    max: 8,
                    value: _mouseFeelSecond,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideMouseFeelSecond
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // カッピング項目入力画面2_2
  Widget _secondCuppingDataSecond() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Text(
            'カッピング 3/3',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: 12
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(50, 50, 50, 0),
          child: Column(
            children: <Widget>[
              Text('アフターテイスト'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('313131'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_afterTasteSecond',
                    min: 0,
                    max: 8,
                    value: _afterTasteSecond,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideAfterTasteSecond
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Column(
            children: <Widget>[
              Text('フレーバー'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('313131'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_flavorSecond',
                    min: 0,
                    max: 8,
                    value: _flavorSecond,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideFlavorSecond
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Column(
            children: <Widget>[
              Text('バランス'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('313131'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_balanceSecond',
                    min: 0,
                    max: 8,
                    value: _balanceSecond,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideBalanceSecond
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(50, 0, 50, 4),
          child: Column(
            children: <Widget>[
              Text('オーバーオール'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 10,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('313131'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_overallSecond',
                    min: 0,
                    max: 8,
                    value: _overallSecond,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideOverallSecond
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // カッピング項目入力画面2_3
  Widget _thirdCuppingDataSecond() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Text(
            'カッピング 4/4',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: 12
            ),
          ),
        ),
        Container(
          height: 50,
          margin: EdgeInsets.fromLTRB(0, 170, 0, 106),
          child: ElevatedButton(
            onPressed: () {
              _realTimeCuppingData = _setCuppingData();
              _writeCuppingData(_realTimeCuppingData, this._uid);

              if (this._timer != null) {
                // タイマーをストップする
                this._timer.cancel();
              }

              // ユーザー画面へ遷移
              Navigator.of(context).pushReplacementNamed('/home');
            },
            style: ElevatedButton.styleFrom(
              primary: HexColor('313131'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)
              ),
            ),
            child: Text(
              'カッピングデータを保存',
              style: TextStyle(
                  color:Colors.white,
                  fontSize: 20.0
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buttonOneAble() {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              color: HexColor('e7e7e7'),
            ),
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 8, 8),
              child: IconButton(
                icon: Icon(
                  Icons.looks_one,
                  color: HexColor('313131'),
                  size: 40
                ),
                onPressed: () {},
              ),
            )
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 8, 8),
            child: IconButton(
              icon: Icon(
                Icons.looks_two,
                  color: HexColor('e7e7e7'),
                size: 40
              ),
              onPressed: () {
                setState(() {
                  this._selectIndex = 3;
                  this._selectCoffeeIndex = 1;
                });
              },
            ),
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    content: Text('カッピングを終了しますか？'),
                    actions: <Widget>[
                      // ボタン領域
                      ElevatedButton(
                        child: Text('Cancel'),
                        style: ElevatedButton.styleFrom(
                          primary: HexColor('313131'),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      ElevatedButton(
                        child: Text('OK'),
                        style: ElevatedButton.styleFrom(
                          primary: HexColor('313131'),
                        ),
                        onPressed: () {

                          // 1杯目のカッピング情報を登録
                          _realTimeCuppingData = _setCuppingData();
                          _writeCuppingData(_realTimeCuppingData, this._uid);

                          // 2杯目のコーヒーがカッピングされていた場合
                          if (
                            this._coffeeNameSecond != '' &&
                            this._countrySecond != '' &&
                            this._processSecond != ''
                          ) {
                            // 2杯目のカッピング情報を登録
                            _realTimeCuppingDataSecond = _setCuppingDataSecond();
                            _writeCuppingData(_realTimeCuppingDataSecond, this._uid);
                          }

                          // タイマーが起動していた場合
                          if (this._timer != null) {
                            // タイマーをストップする
                            this._timer.cancel();
                          }

                          // ユーザー画面へ遷移
                          Navigator.pushAndRemoveUntil(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new HomePage()),
                                  (_) => false);

                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(120, 0, 0, 0),
                child: Text(
                  'Cupping Done',
                  style: TextStyle(
                    color: HexColor('e7e7e7'),
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                  ),
                ),
            )
          )
        ],
      )
    );
  }

  Widget _buttonTwoAble() {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 8, 8),
            child: IconButton(
              icon: Icon(
                Icons.looks_one,
                color: HexColor('e7e7e7'),
                size: 40
              ),
              onPressed: () {
                setState(() {
                  this._selectIndex = 0;
                  this._selectCoffeeIndex = 0;
                });
              },
            ),
          ),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                color: HexColor('e7e7e7'),
              ),
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 8, 8),
                child: IconButton(
                  icon: Icon(
                      Icons.looks_two,
                      color: HexColor('313131'),
                      size: 40
                  ),
                  onPressed: () {},
                ),
              )
          ),
          InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      // title: Text("タイトル"),
                      content: Text('カッピングを終了しますか？'),
                      actions: <Widget>[
                        // ボタン領域
                        ElevatedButton(
                          child: Text('Cancel'),
                          style: ElevatedButton.styleFrom(
                            primary: HexColor('313131'),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        ElevatedButton(
                          child: Text('OK'),
                          style: ElevatedButton.styleFrom(
                            primary: HexColor('313131'),
                          ),
                          onPressed: () {

                            // 1杯目のカッピング情報を登録
                            _realTimeCuppingData = _setCuppingData();
                            _writeCuppingData(_realTimeCuppingData, this._uid);

                            // 2杯目のコーヒーがカッピングされていた場合
                            if (
                              this._coffeeNameSecond != '' &&
                              this._countrySecond != '' &&
                              this._processSecond != ''
                            ) {
                              // 2杯目のカッピング情報を登録
                              _realTimeCuppingDataSecond = _setCuppingDataSecond();
                              _writeCuppingData(_realTimeCuppingDataSecond, this._uid);
                            }

                            // タイマーが起動していた場合
                            if (this._timer != null) {
                              // タイマーをストップする
                              this._timer.cancel();
                            }

                            // ユーザー画面へ遷移
                            Navigator.pushAndRemoveUntil(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new HomePage()),
                                    (_) => false);

                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(120, 0, 0, 0),
                child: Text(
                  'Cupping Done',
                  style: TextStyle(
                      color: HexColor('e7e7e7'),
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                  ),
                ),
              )
          )
        ],
      )
    );
  }

  // カッピングしたデータをMap型に詰め直すメソッド1
  Map<String, dynamic> _setCuppingData() {
    Map<String, dynamic> cuppingData = new Map<String, dynamic>();

    cuppingData['coffee_name'] = _coffeeName;
    cuppingData['country'] = _country;
    cuppingData['process'] = _process;
    cuppingData['sweetness'] = _sweetness;
    cuppingData['acidity'] = _acidity;
    cuppingData['mousefeel'] = _mouseFeel;
    cuppingData['aftertaste'] = _afterTaste;
    cuppingData['cleancup'] = _cleanCup;
    cuppingData['balance'] = _balance;
    cuppingData['flavor'] = _flavor;
    cuppingData['overall'] = _overall;
    cuppingData['favorite'] = false;
    cuppingData['cupped_date'] = Timestamp.fromDate(DateTime.now());

    // 値が未入力だった場合
    if (cuppingData['coffee_name'] == '') {
      cuppingData['coffee_name'] = 'Some Coffee';
    }
    if (cuppingData['country'] == '') {
      cuppingData['country'] = 'Some Country';
    }
    if (cuppingData['process'] == '') {
      cuppingData['process'] = 'Some Process';
    }

    cuppingData['coffee_score'] =
      _cleanCup + _sweetness + _acidity + _mouseFeel + _afterTaste +
      _balance + _flavor + _overall + 36;
    return cuppingData;
  }

  // カッピングしたデータをMap型に詰め直すメソッド2
  Map<String, dynamic> _setCuppingDataSecond() {
    Map<String, dynamic> cuppingDataSecond = new Map<String, dynamic>();

    cuppingDataSecond['coffee_name'] = _coffeeNameSecond;
    cuppingDataSecond['country'] = _countrySecond;
    cuppingDataSecond['process'] = _processSecond;
    cuppingDataSecond['sweetness'] = _sweetnessSecond;
    cuppingDataSecond['acidity'] = _aciditySecond;
    cuppingDataSecond['mousefeel'] = _mouseFeelSecond;
    cuppingDataSecond['aftertaste'] = _afterTasteSecond;
    cuppingDataSecond['cleancup'] = _cleanCupSecond;
    cuppingDataSecond['balance'] = _balanceSecond;
    cuppingDataSecond['flavor'] = _flavorSecond;
    cuppingDataSecond['overall'] = _overallSecond;
    cuppingDataSecond['favorite'] = false;
    cuppingDataSecond['cupped_date'] = Timestamp.fromDate(DateTime.now());

    // 値が未入力だった場合
    if (cuppingDataSecond['coffee_name'] == '') {
      cuppingDataSecond['coffee_name'] = 'Some Coffee';
    }
    if (cuppingDataSecond['country'] == '') {
      cuppingDataSecond['country'] = 'Some Country';
    }
    if (cuppingDataSecond['process'] == '') {
      cuppingDataSecond['process'] = 'Some Process';
    }

    cuppingDataSecond['coffee_score'] =
        _cleanCup + _sweetness + _acidity + _mouseFeel + _afterTaste +
            _balance + _flavor + _overall + 36;
    return cuppingDataSecond;
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
