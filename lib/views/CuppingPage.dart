import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuppers_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:async';

import 'package:flutter/services.dart';

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
  TextEditingController _varietyController;
  TextEditingController _processController;
  TextEditingController _roasterController;
  TextEditingController _flavorTextController;
  TextEditingController _commentController;

  TextEditingController _coffeeNameControllerSecond;
  TextEditingController _countryControllerSecond;
  TextEditingController _varietyControllerSecond;
  TextEditingController _processControllerSecond;
  TextEditingController _roasterControllerSecond;
  TextEditingController _flavorTextControllerSecond;
  TextEditingController _commentControllerSecond;

  @override
  void initState() {
    super.initState();
    _coffeeNameController = new TextEditingController(text: _coffeeName);
    _countryController = new TextEditingController(text: _country);
    _varietyController =  new TextEditingController(text: _variety);
    _processController = new TextEditingController(text: _process);
    _roasterController = new TextEditingController(text: _roaster);
    _flavorTextController = new TextEditingController(text: _flavorText);
    _commentController = new TextEditingController(text: _comment);

    _coffeeNameControllerSecond = new TextEditingController(text: _coffeeNameSecond);
    _countryControllerSecond = new TextEditingController(text: _countrySecond);
    _varietyController =  new TextEditingController(text: _varietySecond);
    _processControllerSecond = new TextEditingController(text: _processSecond);
    _roasterControllerSecond = new TextEditingController(text: _roasterSecond);
    _flavorTextControllerSecond = new TextEditingController(text: _flavorTextSecond);
    _commentControllerSecond = new TextEditingController(text: _commentSecond);
  }

  // データ書き込み処理時に使用するMap型State
  Map<String, dynamic> _realTimeCuppingData = new Map<String, dynamic>();
  Map<String, dynamic> _realTimeCuppingDataSecond = new Map<String, dynamic>();

  // カッピング項目のState_1
  String _coffeeName = '';
  String _country = '';
  String _variety = '';
  String _elevation = '0';
  String _process = '';
  String _roaster = '';
  double _sweetness = 4.0;
  double _acidity = 4.0;
  double _cleanCup = 4.0;
  double _mouseFeel = 4.0;
  double _afterTaste = 4.0;
  double _balance = 4.0;
  double _flavor = 4.0;
  double _overall = 4.0;
  String _flavorText = '';
  String _comment = '';

  void _coffeeNameChanged(String str) => setState(() { _coffeeName = str; });
  void _countryChanged(String str) => setState(() { _country = str; });
  void _varietyChanged(String str) => setState(() { _variety = str; });
  void _elevationChanged(String str) => setState(() { _elevation = str; });
  void _processChanged(String str) => setState(() { _process = str; });
  void _roasterChanged(String str) => setState(() { _roaster = str; });
  void _slideSweetness(double e) => setState(() { _sweetness = e; });
  void _slideAcidity(double e) => setState(() { _acidity = e; });
  void _slideCleanCup(double e) => setState(() { _cleanCup = e; });
  void _slideMouseFeel(double e) => setState(() { _mouseFeel = e; });
  void _slideAfterTaste(double e) => setState(() { _afterTaste = e; });
  void _slideBalance(double e) => setState(() { _balance = e; });
  void _slideFlavor(double e) => setState(() { _flavor = e; });
  void _slideOverall(double e) => setState(() { _overall = e; });
  void _flavorTextChanged(String str) => setState(() { _flavorText = str; });
  void _commentChanged(String str) => setState(() { _comment = str; });

  // カッピング項目のState_2
  String _coffeeNameSecond = '';
  String _countrySecond = '';
  String _varietySecond = '';
  String _elevationSecond = '0';
  String _processSecond = '';
  String _roasterSecond = '';
  double _sweetnessSecond = 4.0;
  double _aciditySecond = 4.0;
  double _cleanCupSecond = 4.0;
  double _mouseFeelSecond = 4.0;
  double _afterTasteSecond = 4.0;
  double _balanceSecond = 4.0;
  double _flavorSecond = 4.0;
  double _overallSecond = 4.0;
  String _flavorTextSecond = '';
  String _commentSecond = '';

  void _coffeeNameSecondChanged(String str) => setState(() { _coffeeNameSecond = str; });
  void _countrySecondChanged(String str) => setState(() { _countrySecond = str; });
  void _varietySecondChanged(String str) => setState(() { _varietySecond = str; });
  void _elevationSecondChanged(String str) => setState(() { _elevationSecond = str; });
  void _processSecondChanged(String str) => setState(() { _processSecond = str; });
  void _roasterSecondChanged(String str) => setState(() { _roasterSecond = str; });
  void _slideSweetnessSecond(double e) => setState(() { _sweetnessSecond = e; });
  void _slideAciditySecond(double e) => setState(() { _aciditySecond = e; });
  void _slideCleanCupSecond(double e) => setState(() { _cleanCupSecond = e; });
  void _slideMouseFeelSecond(double e) => setState(() { _mouseFeelSecond = e; });
  void _slideAfterTasteSecond(double e) => setState(() { _afterTasteSecond = e; });
  void _slideBalanceSecond(double e) => setState(() { _balanceSecond = e; });
  void _slideFlavorSecond(double e) => setState(() { _flavorSecond = e; });
  void _slideOverallSecond(double e) => setState(() { _overallSecond = e; });
  void _flavorTextSecondChanged(String str) => setState(() { _flavorTextSecond = str; });
  void _commentSecondChanged(String str) => setState(() { _commentSecond = str; });

  @override
  Widget build(BuildContext context) {

    // 画面サイズを取得
    final Size size = MediaQuery.of(context).size;
    final double _width = size.width;
    final double _height = size.height;

    // ログイン中のユーザーIDを取得
    _uid = FirebaseAuth.instance.currentUser.uid;

    // カッピングページ表示項目の制御
    List<Widget> _pageList = [
      _firstCoffeeInfoField(_width, _height), // 0
      _secondCoffeeInfoField(_width, _height), // 1
      _firstCuppingData(_width, _height), // 2
      _secondCuppingData(_width, _height), // 3
      _thirdCuppingData(_width, _height), // 4
      _fourthCuppingData(_width, _height), // 5
      _firstCoffeeInfoFieldSecond(), // 5
      _secondCoffeeInfoFieldSecond(), // 6
      _firstCuppingDataSecond(), // 7
      _secondCuppingDataSecond(), // 8
      _thirdCuppingDataSecond(), // 9
    ];

    // カッピングコーヒーの制御
    List<Widget> _coffeeIndex = [
      _buttonOneAble(_width, _height),
      _buttonTwoAble(_width, _height),
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
      floatingActionButton: Column(
        verticalDirection: VerticalDirection.up, // childrenの先頭を下に配置
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            backgroundColor: HexColor('e7e7e7'),
            onPressed: () {

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
                }
              );
            },
            child: Icon(Icons.done, color: HexColor('313131')),
          ),
        ],
      ),
      body: Container(
        color: HexColor('313131'),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(_width / 25, _height / 120, _width / 25, 0),
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
                    margin: EdgeInsets.fromLTRB(0, _height / 26, 0, _height / 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                            icon: const Icon(Icons.navigate_before),
                            onPressed: _selectIndex == 0 || _selectIndex == 6 ? null : () {
                              if(_selectIndex > 0) {
                                setState(() {
                                  _selectIndex--;
                                });
                              }
                            }
                        ),
                        IconButton(
                            icon: const Icon(Icons.navigate_next),
                            onPressed: _selectIndex == 5 || _selectIndex == 10 ? null: () {
                              if(_selectIndex < 10) {
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
              child: Column(
                children: <Widget>[
                  Center(
                   child: Text(
                     '${this._countMinuteStr}:${this._countSecondStr}',
                     style: TextStyle(
                         fontSize: _width / 6,
                         color: HexColor('e7e7e7')
                     ),
                   ),
                  ),
                  Row(
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
                ],
              )
            ),
          ],
        )
      )
    );
  }

  // コーヒー名などを入力する部分1_1
  Widget _firstCoffeeInfoField(double width, double height) {
    return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, height / 18, 0, 0),
            child: Text(
              'カッピング 1/6',
              style: TextStyle(
                fontSize: width / 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, height / 120, 0, 0),
            child: Text(
              '各項目を評価してください',
              style: TextStyle(
                fontSize: width / 30
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width / 6.5, height / 18, width / 6.5, 0),
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
            margin: EdgeInsets.fromLTRB(width / 6.5, height / 40, width / 6.5, 0),
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
            margin: EdgeInsets.fromLTRB(width / 6.5, height / 40, width / 6.5, height / 41),
            child: TextField(
              controller: _varietyController,
              decoration: InputDecoration(
                  labelText: 'Variety',
                  hintText: 'Bourbon'
              ),
              keyboardType: TextInputType.text,
              onChanged: _varietyChanged,
            ),
          )
        ]
    );
  }

  // コーヒー名などを入力する部分1_2
  Widget _secondCoffeeInfoField(double width, double height) {
    return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, height / 18, 0, 0),
            child: Text(
              'カッピング 2/6',
              style: TextStyle(
                fontSize: width / 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, height / 120, 0, 0),
            child: Text(
              '各項目を評価してください',
              style: TextStyle(
                  fontSize: width / 30
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width / 6.5, height / 18, width / 6.5, 0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: 'Elevation',
                  hintText: '1500'
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: _elevationChanged,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width / 6.5, height / 40, width / 6.5, 0),
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
          Container(
            margin: EdgeInsets.fromLTRB(width / 6.5, height / 40, width / 6.5, height / 41),
            child: TextField(
              controller: _roasterController,
              decoration: InputDecoration(
                  labelText: 'Roaster',
                  hintText: 'Reverbed Coffee'
              ),
              keyboardType: TextInputType.text,
              onChanged: _roasterChanged,
            ),
          ),
        ]
    );
  }

  // カッピング項目入力画面1_1
  Widget _firstCuppingData(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height / 18, 0, 0),
          child: Text(
            'カッピング 3/6',
            style: TextStyle(
              fontSize: width / 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, height / 120, 0, 0),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: width / 30
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width / 6.5, height / 18, width / 6.5, 0),
          child: Column(
            children: <Widget>[
              Text('クリーンカップ'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: width / 48,
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
          margin: EdgeInsets.fromLTRB(width / 6.5, height / 80, width / 6.5, 0),
          child: Column(
            children: <Widget>[
              Text('甘さ'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: width / 48,
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
          margin: EdgeInsets.fromLTRB(width / 6.5, height / 80, width / 6.5, height / 80),
          child: Column(
            children: <Widget>[
              Text('酸'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: width / 48,
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
      ],
    );
  }

  // カッピング項目入力画面1_2
  Widget _secondCuppingData(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height / 18, 0, 0),
          child: Text(
            'カッピング 4/6',
            style: TextStyle(
              fontSize: width / 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, height / 120, 0, 0),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: width / 30
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width / 6.5, height / 18, width / 6.5, 0),
          child: Column(
            children: <Widget>[
              Text('マウスフィール'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: width / 48,
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
        Container(
          margin: EdgeInsets.fromLTRB(width / 6.5, height / 80, width / 6.5, 0),
          child: Column(
            children: <Widget>[
              Text('アフターテイスト'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: width / 48,
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
          margin: EdgeInsets.fromLTRB(width / 6.5, height / 80, width / 6.5, height / 80),
          child: Column(
            children: <Widget>[
              Text('フレーバー'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: width / 48,
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
      ],
    );
  }

  // カッピング項目入力画面1_3
  Widget _thirdCuppingData(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height / 18, 0, 0),
          child: Text(
            'カッピング 5/6',
            style: TextStyle(
              fontSize: width / 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, height / 120, 0, 0),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: width / 30
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width / 6.5, height / 18, width / 6.5, 0),
          child: Column(
            children: <Widget>[
              Text('バランス'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: width / 48,
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
          margin: EdgeInsets.fromLTRB(width / 6.5, height / 80, width / 6.5, height / 9.1),
          child: Column(
            children: <Widget>[
              Text('オーバーオール'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: width / 48,
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

  // カッピング項目入力画面1_4
  Widget _fourthCuppingData(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height / 18, 0, 0),
          child: Text(
            'カッピング 6/6',
            style: TextStyle(
              fontSize: width / 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, height / 120, 0, 0),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: width / 30
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width / 6.5, height / 10, width / 6.5, 0),
          child: TextField(
            controller: _flavorTextController,
            decoration: InputDecoration(
              labelText: 'Flavor Text',
              hintText: 'Lemon, Peach, Strawberry',
            ),
            keyboardType: TextInputType.text,
            onChanged: _flavorTextChanged,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width / 6.5, height / 40, width / 6.5, height / 12.9),
          child: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              labelText: 'Comment',
              hintText: 'Silky, Complex, BrightAcidity',
            ),
            keyboardType: TextInputType.text,
            onChanged: _commentChanged,
          ),
        )
      ],
    );
  }

  // コーヒー名などを入力する部分2_1
  Widget _firstCoffeeInfoFieldSecond() {
    return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Text(
              'カッピング 1/4',
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
            margin: EdgeInsets.fromLTRB(50, 20, 50, 0),
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
            margin: EdgeInsets.fromLTRB(50, 10, 50, 0),
            child: TextField(
              controller: _varietyControllerSecond,
              decoration: InputDecoration(
                  labelText: 'Variety',
                  hintText: 'Bourbon'
              ),
              keyboardType: TextInputType.text,
              onChanged: _varietySecondChanged,
            ),
          )
        ]
    );
  }

  // コーヒー名などを入力する部分2_1
  Widget _secondCoffeeInfoFieldSecond() {
    return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Text(
              'カッピング 1/4',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(50, 20, 50, 0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: 'Elevation',
                  hintText: '1500'
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: _elevationSecondChanged,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(50, 1, 50, 0),
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
            'カッピング 2/4',
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
          margin: EdgeInsets.fromLTRB(50, 5, 50, 0),
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
          margin: EdgeInsets.fromLTRB(50, 5, 50, 0),
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
          margin: EdgeInsets.fromLTRB(50, 5, 50, 4),
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
            'カッピング 3/4',
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
          margin: EdgeInsets.fromLTRB(50, 5, 50, 0),
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
          margin: EdgeInsets.fromLTRB(50, 5, 50, 0),
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
          margin: EdgeInsets.fromLTRB(50, 5, 50, 4),
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
            margin: EdgeInsets.fromLTRB(0, 90, 0, 0),
            child: Text(
                'フレーバーテキスト'
            )
        ),
        Container(
          margin: EdgeInsets.fromLTRB(50, 10, 50, 0),
          child: TextField(
            controller: _flavorTextControllerSecond,
            decoration: InputDecoration(
              hintText: 'Lemon, Peach, Strawberry',
            ),
            keyboardType: TextInputType.text,
            onChanged: _flavorTextSecondChanged,
          ),
        ),
        Container(
            margin: EdgeInsets.fromLTRB(0, 37, 0, 0),
            child: Text(
                'コメント'
            )
        ),
        Container(
          margin: EdgeInsets.fromLTRB(50, 10, 50, 60),
          child: TextField(
            controller: _commentControllerSecond,
            decoration: InputDecoration(
              hintText: 'Silky, Complex, BrightAcidity',
            ),
            keyboardType: TextInputType.text,
            onChanged: _commentSecondChanged,
          ),
        )
      ],
    );
  }

  Widget _buttonOneAble(double width, double height) {
    return Container(
      margin: EdgeInsets.fromLTRB(width / 25, 0, width / 25, height / 100),
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
              margin: EdgeInsets.fromLTRB(0, 0, width / 48, height / 80),
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
            margin: EdgeInsets.fromLTRB(0, 0, width / 48, height / 100),
            child: IconButton(
              icon: Icon(
                Icons.looks_two,
                  color: HexColor('e7e7e7'),
                size: 40
              ),
              onPressed: () {
                setState(() {
                  this._selectIndex = 5;
                  this._selectCoffeeIndex = 1;
                });
              },
            ),
          ),
        ],
      )
    );
  }

  Widget _buttonTwoAble(double width, double height) {
    return Container(
      margin: EdgeInsets.fromLTRB(width / 25, 0, width / 25, height / 100),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, width / 48, height / 80),
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
                margin: EdgeInsets.fromLTRB(0, 0, width / 48, height / 100),
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
        ],
      )
    );
  }

  // カッピングしたデータをMap型に詰め直すメソッド1
  Map<String, dynamic> _setCuppingData() {
    Map<String, dynamic> cuppingData = new Map<String, dynamic>();

    cuppingData['coffee_name'] = _coffeeName;
    cuppingData['country'] = _country;
    cuppingData['variety'] = _variety;
    cuppingData['elevation'] = int.parse(_elevation); // 数値型に変換
    cuppingData['process'] = _process;
    cuppingData['roaster'] = _roaster;
    cuppingData['sweetness'] = _sweetness;
    cuppingData['acidity'] = _acidity;
    cuppingData['mousefeel'] = _mouseFeel;
    cuppingData['aftertaste'] = _afterTaste;
    cuppingData['cleancup'] = _cleanCup;
    cuppingData['balance'] = _balance;
    cuppingData['flavor'] = _flavor;
    cuppingData['overall'] = _overall;
    cuppingData['flavor_text'] = _flavorText;
    cuppingData['comment'] = _comment;
    cuppingData['favorite'] = false;
    cuppingData['cupped_date'] = Timestamp.fromDate(DateTime.now());

    // 値が未入力だった場合
    if (cuppingData['coffee_name'] == '') {
      cuppingData['coffee_name'] = 'Some Coffee';
    }
    if (cuppingData['country'] == '') {
      cuppingData['country'] = 'Some Country';
    }
    if (cuppingData['variety'] == '') {
      cuppingData['variety'] = 'Some Variety';
    }
    if (cuppingData['process'] == '') {
      cuppingData['process'] = 'Some Process';
    }
    if (cuppingData['roaster'] == '') {
      cuppingData['roaster'] = 'Some Roaster';
    }
    if (cuppingData['flavor_text'] == '') {
      cuppingData['flavor_text'] = 'No Flavor Text';
    }
    if (cuppingData['comment'] == '') {
      cuppingData['comment'] = 'No Comment';
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
    cuppingDataSecond['variety'] = _varietySecond;
    cuppingDataSecond['elevation'] = int.parse(_elevationSecond); // 数値型に変換
    cuppingDataSecond['process'] = _processSecond;
    cuppingDataSecond['roaster'] = _roasterSecond;
    cuppingDataSecond['sweetness'] = _sweetnessSecond;
    cuppingDataSecond['acidity'] = _aciditySecond;
    cuppingDataSecond['mousefeel'] = _mouseFeelSecond;
    cuppingDataSecond['aftertaste'] = _afterTasteSecond;
    cuppingDataSecond['cleancup'] = _cleanCupSecond;
    cuppingDataSecond['balance'] = _balanceSecond;
    cuppingDataSecond['flavor'] = _flavorSecond;
    cuppingDataSecond['overall'] = _overallSecond;
    cuppingDataSecond['flavor_text'] = _flavorTextSecond;
    cuppingDataSecond['comment'] = _commentSecond;
    cuppingDataSecond['favorite'] = false;
    cuppingDataSecond['cupped_date'] = Timestamp.fromDate(DateTime.now());

    // 値が未入力だった場合
    if (cuppingDataSecond['coffee_name'] == '') {
      cuppingDataSecond['coffee_name'] = 'Some Coffee';
    }
    if (cuppingDataSecond['country'] == '') {
      cuppingDataSecond['country'] = 'Some Country';
    }
    if (cuppingDataSecond['variety'] == '') {
      cuppingDataSecond['variety'] = 'Some Variety';
    }
    if (cuppingDataSecond['process'] == '') {
      cuppingDataSecond['process'] = 'Some Process';
    }
    if (cuppingDataSecond['roaster'] == '') {
      cuppingDataSecond['roaster'] = 'Some Roaster';
    }
    if (cuppingDataSecond['flavor_text'] == '') {
      cuppingDataSecond['flavor_text'] = 'No Flavor Text';
    }
    if (cuppingDataSecond['comment'] == '') {
      cuppingDataSecond['comment'] = 'No Comment';
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
