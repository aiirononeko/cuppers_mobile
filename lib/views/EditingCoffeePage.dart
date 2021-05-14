import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

// カッピング情報詳細画面
class EditingCoffeePage extends StatefulWidget {

  final Map<String, dynamic> snapshot;
  final String documentId;
  EditingCoffeePage(this.snapshot, this.documentId);

  @override
  _EditingCoffeePageState createState() => _EditingCoffeePageState();
}

class _EditingCoffeePageState extends State<EditingCoffeePage> {

  String _uid;

  TextEditingController _coffeeNameController;
  TextEditingController _elevationController;
  TextEditingController _roasterController;
  TextEditingController _flavorTextController;
  TextEditingController _commentController;

  String _coffeeName;
  String _elevation;
  String _roaster;
  double _sweetness;
  double _acidity;
  double _cleanCup;
  double _mouseFeel;
  double _afterTaste;
  double _balance;
  double _flavor;
  double _overall;
  String _flavorText;
  String _comment;

  // ドラムピッカー用のリスト型変数
  String _selectedCountry = 'Country';
  final List<String> _countries = [
    'Brazil',
    'Colombia',
    'Indonesia',
    'Ethiopia',
    'Mexico',
    'Guatemala',
    'Peru',
    'Honduras',
    'Costa Rica',
    'El Salvador',
    'Nicaragua',
    'Ecuador',
    'Thai',
    'Tanzania',
    'Dominicana',
    'Kenya',
    'Burundi',
    'Rwanda',
    'Bolivia',
    'Panama',
    'Other Country'
  ];

  // ドラムピッカー用のリスト型変数
  String _selectedVariety = 'Variety';
  final List<String> _varieties = [
    'Typica',
    'Bourbon',
    'Yellow Bourbon',
    'Red Bourbon',
    'Cattura',
    'Mundo Novo',
    'Catuai',
    'MaragoGype',
    'San Ramon',
    'Purpurascens',
    'Kent',
    'Pacas',
    'Akkaya',
    'Pacamara',
    'Villa Sarchi',
    'Arusha',
    'Geisha',
    'SL28',
    'SL34',
    'Other Variety'
  ];

  // ドラムピッカー用のリスト型変数
  String _selectedProcess = 'Process';
  final List<String> _processes = [
    'Washed',
    'Fully Washed',
    'Natural',
    'Pulped Natural',
    'Honey Process',
    'White Honey',
    'Golden Honey',
    'Yellow Honey',
    'Red Honey',
    'Black Honey',
    'Traditional Sumatran Process',
    'Anaerobic',
    'Anaerobic Natural',
    'Anaerobic Washed',
    'Anaerobic Honey',
    'Other Process'
  ];

  @override
  void initState() {
    super.initState();

    _fetchCuppingData();

    _coffeeNameController = new TextEditingController(text: _coffeeName);
    _elevationController =  new TextEditingController(text: _elevation);
    _roasterController = new TextEditingController(text: _roaster);
    _flavorTextController = new TextEditingController(text: _flavorText);
    _commentController = new TextEditingController(text: _comment);

    // ログイン中のユーザーIDを取得
    _uid = FirebaseAuth.instance.currentUser.uid;
  }

  void _coffeeNameChanged(String str) => setState(() { _coffeeName = str; });
  void _elevationChanged(String str) => setState(() { _elevation = str; });
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

  // カッピングページ表示切り替え機能で使用する変数
  int _selectIndex = 0;

  Map<String, dynamic> _realTimeCuppingData = new Map<String, dynamic>();

  @override
  Widget build(BuildContext context) {

    // 画面サイズを取得
    final Size size = MediaQuery.of(context).size;
    final double _width = size.width;
    final double _height = size.height;

    // カッピングページ表示項目の制御
    List<Widget> _pageList = [
      _firstCoffeeInfoField(_width, _height), // 0
      _secondCoffeeInfoField(_width, _height), // 1
      _firstCuppingData(_width, _height), // 2
      _secondCuppingData(_width, _height), // 3
      _thirdCuppingData(_width, _height), // 4
      _fourthCuppingData(_width, _height), // 5
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

                              // カッピング情報を更新
                              _realTimeCuppingData = _setCuppingData();
                              _updateCuppingData(_realTimeCuppingData, this._uid, widget.documentId);

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
                  height: _height * 0.73,
                  margin: EdgeInsets.fromLTRB(_width * 0.05, 0, _width * 0.05, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: HexColor('e7e7e7'),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: _height * 0.63,
                        child: _pageList[_selectIndex],
                      ),
                      Container(
                        // margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                                icon: const Icon(
                                  Icons.navigate_before,
                                ),
                                onPressed: _selectIndex == 0 ? null : () {
                                  setState(() {
                                    _selectIndex--;
                                  });
                                }
                            ),
                            IconButton(
                                icon: const Icon(
                                  Icons.navigate_next,
                                ),
                                onPressed: _selectIndex == 5 ? null: () {
                                  setState(() {
                                    _selectIndex++;
                                  });
                                }
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
        )
    );
  }

  // カッピングデータを取得してメンバ変数に格納するメソッド
  void _fetchCuppingData() async {

    setState(() {
      _coffeeName = widget.snapshot['coffee_name'];
      _selectedCountry = widget.snapshot['country'];
      _selectedVariety = widget.snapshot['variety'];
      _elevation = widget.snapshot['elevation'].toString(); // int型をString型に変換
      _selectedProcess = widget.snapshot['process'];
      _roaster = widget.snapshot['roaster'];
      _cleanCup = widget.snapshot['cleancup'];
      _sweetness = widget.snapshot['sweetness'];
      _acidity = widget.snapshot['acidity'];
      _mouseFeel = widget.snapshot['mousefeel'];
      _flavor = widget.snapshot['flavor'];
      _afterTaste = widget.snapshot['aftertaste'];
      _balance = widget.snapshot['balance'];
      _overall = widget.snapshot['overall'];
      _flavorText = widget.snapshot['flavor_text'];
      _comment = widget.snapshot['comment'];
    });
  }

  // コーヒー名などを入力する部分1_1
  Widget _firstCoffeeInfoField(double width, double height) {

    return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, height * 0.08, 0, height * 0.01),
            child: Text(
              'カッピング 1/6',
              style: TextStyle(
                fontSize: height * 0.03,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.08),
            child: Text(
              '各項目を評価してください',
              style: TextStyle(
                  fontSize: height * 0.02
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.065),
            child: TextField(
              controller: _coffeeNameController,
              decoration: InputDecoration(
                labelText: 'Coffee Name',
                hintText: 'Yirgacheffe Konga',
              ),
              style: TextStyle(
                fontSize: height * 0.02
              ),
              keyboardType: TextInputType.text,
              onChanged: _coffeeNameChanged,
            ),
          ),
          Container(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.01),
                        child: Text(
                          this._selectedCountry,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: height * 0.02
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.055),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _showModalCountriesPicker(context);
                },
              )
          ),
          Container(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.014),
                        child: Text(
                          this._selectedVariety,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: height * 0.02
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _showModalVarietiesPicker(context);
                },
              )
          ),
        ]
    );
  }

  // コーヒー名などを入力する部分1_2
  Widget _secondCoffeeInfoField(double width, double height) {
    return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, height * 0.08, 0, height * 0.01),
            child: Text(
              'カッピング 2/6',
              style: TextStyle(
                fontSize: height * 0.03,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.08),
            child: Text(
              '各項目を評価してください',
              style: TextStyle(
                  fontSize: height * 0.02
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.065),
            child: TextField(
              controller: _elevationController,
              decoration: InputDecoration(
                  labelText: 'Elevation',
                  hintText: '1500'
              ),
              style: TextStyle(
                fontSize: height * 0.02
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: _elevationChanged,
            ),
          ),
          Container(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.01),
                        child: Text(
                          this._selectedProcess,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: height * 0.02
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _showModalProcessesPicker(context);
                },
              )
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
            child: TextField(
              controller: _roasterController,
              decoration: InputDecoration(
                  labelText: 'Roaster',
                  hintText: 'Reverbed Coffee'
              ),
              style: TextStyle(
                fontSize: height * 0.02
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
          margin: EdgeInsets.fromLTRB(0, height * 0.08, 0, height * 0.01),
          child: Text(
            'カッピング 3/6',
            style: TextStyle(
              fontSize: height * 0.03,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.08),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.02
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.045),
            child: Column(
              children: <Widget>[
                Text(
                  'CleanCup',
                  style: TextStyle(
                    fontSize: height * 0.015
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: height * 0.01,
                    thumbColor: HexColor('313131'),
                    overlayColor: HexColor('808080').withAlpha(80),
                    activeTrackColor: HexColor('313131'),
                    inactiveTrackColor: HexColor('cccccc'),
                    inactiveTickMarkColor: HexColor('cccccc'),
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
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.045),
          child: Column(
            children: <Widget>[
              Text(
                'Sweetness',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
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
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
          child: Column(
            children: <Widget>[
              Text(
                'Acidity',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
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
          margin: EdgeInsets.fromLTRB(0, height * 0.08, 0, height * 0.01),
          child: Text(
            'カッピング 4/6',
            style: TextStyle(
              fontSize: height * 0.03,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.08),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.02
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.045),
          child: Column(
            children: <Widget>[
              Text(
                'MouseFeel',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
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
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.045),
          child: Column(
            children: <Widget>[
              Text(
                'AfterTaste',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
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
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
          child: Column(
            children: <Widget>[
              Text(
                'Flavor',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
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
          margin: EdgeInsets.fromLTRB(0, height * 0.08, 0, height * 0.01),
          child: Text(
            'カッピング 5/6',
            style: TextStyle(
              fontSize: height * 0.03,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.08),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.02
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.045),
          child: Column(
            children: <Widget>[
              Text(
                'Balance',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
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
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.045),
          child: Column(
            children: <Widget>[
              Text(
                'OverAll',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
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
          margin: EdgeInsets.fromLTRB(0, height * 0.08, 0, height * 0.01),
          child: Text(
            'カッピング 6/6',
            style: TextStyle(
              fontSize: height * 0.03,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.08),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.02
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.05),
          child: TextField(
            controller: _flavorTextController,
            decoration: InputDecoration(
              labelText: 'Flavor Text',
              hintText: 'Lemon, Peach, Strawberry',
            ),
            style: TextStyle(
                fontSize: height * 0.02
            ),
            keyboardType: TextInputType.text,
            onChanged: _flavorTextChanged,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
          child: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              labelText: 'Comment',
              hintText: 'Silky, Complex, BrightAcidity',
            ),
            style: TextStyle(
                fontSize: height * 0.02
            ),
            keyboardType: TextInputType.text,
            onChanged: _commentChanged,
          ),
        )
      ],
    );
  }

  Widget _pickerItem(String str) {
    return Text(
      str,
      style: const TextStyle(fontSize: 26),
    );
  }

  void _onSelectedItemChanged(int index) {
    setState(() {
      _selectedCountry = _countries[index];
    });
  }

  void _showModalCountriesPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _countries.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedItemChanged,
              scrollController: FixedExtentScrollController(
                initialItem: _countries.indexOf(_selectedCountry),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSelectedVarietyChanged(int index) {
    setState(() {
      _selectedVariety = _varieties[index];
    });
  }

  void _showModalVarietiesPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _varieties.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedVarietyChanged,
              scrollController: FixedExtentScrollController(
                initialItem: _varieties.indexOf(_selectedVariety),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSelectedProcessChanged(int index) {
    setState(() {
      _selectedProcess = _processes[index];
    });
  }

  void _showModalProcessesPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _processes.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedProcessChanged,
              scrollController: FixedExtentScrollController(
                initialItem: _processes.indexOf(_selectedProcess),
              ),
            ),
          ),
        );
      },
    );
  }

  // カッピングしたデータをMap型に詰め直すメソッド1
  Map<String, dynamic> _setCuppingData() {
    Map<String, dynamic> cuppingData = new Map<String, dynamic>();

    cuppingData['coffee_name'] = _coffeeName;
    cuppingData['country'] = _selectedCountry;
    cuppingData['variety'] = _selectedVariety;
    if (_elevation == '') {
      cuppingData['elevation'] = 0;
    } else {
      cuppingData['elevation'] = int.parse(_elevation); // 数値型に変換
    }
    cuppingData['process'] = _selectedProcess;
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
    // cuppingData['favorite'] = false;
    // cuppingData['cupped_date'] = Timestamp.fromDate(DateTime.now()); // 日付は変更しない

    // 値が未入力だった場合
    if (cuppingData['coffee_name'] == '') {
      cuppingData['coffee_name'] = 'Some Coffee';
    }
    if (cuppingData['country'] == 'Country') {
      cuppingData['country'] = 'Some Country';
    }
    if (cuppingData['variety'] == 'Variety') {
      cuppingData['variety'] = 'Some Variety';
    }
    if (cuppingData['process'] == 'Process') {
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

  // Firestoreのデータを更新するメソッド
  void _updateCuppingData(Map<String, dynamic> cuppingData, String uid, String documentId) async {
    await FirebaseFirestore.instance
        .collection('CuppedCoffee')
        .doc(uid)
        .collection('CoffeeInfo')
        .doc(documentId)
        .update(cuppingData);
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
