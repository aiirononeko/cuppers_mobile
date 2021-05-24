import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuppers_mobile/services/HexColor.dart';
import 'package:cuppers_mobile/services/MyFirebaseStorage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:intl/intl.dart';

// タイムラインのカッピング情報詳細画面
class TimelineCoffeePage extends StatefulWidget {

  final Map<String, dynamic> snapshot;
  final String documentId;
  TimelineCoffeePage(this.snapshot, this.documentId);

  @override
  _TimelineCoffeePageState createState() => _TimelineCoffeePageState();
}

class _TimelineCoffeePageState extends State<TimelineCoffeePage> {

  String _uid;

  String _coffeeName;
  String _country;
  String _variety;
  int _elevation;
  String _process;
  String _roaster;
  double _cleanCup;
  double _sweetness;
  double _acidity;
  double _mouseFeel;
  double _flavor;
  double _afterTaste;
  double _balance;
  double _overAll;
  DateTime _cuppedDate;
  double _coffeeScore;
  String _flavorText;
  String _comment;
  List _thumbUp;
  bool _isThumbUp;
  String _cupperUid;
  String _name;

  List<List<int>> _chartValueList = [];

  String _cuppedDateStr = '';

  Image _img;

  @override
  void initState() {
    super.initState();

    // ログイン中のユーザーIDを取得
    _uid = FirebaseAuth.instance.currentUser.uid;
    // カッピング情報をステートに保存
    _fetchCuppingData(_uid, widget.documentId);
    // カッピングした人のユーザーネームを取得
    _getUserName();

    MyFirebaseStorage.downloadFile(_cupperUid).then((img) {
      setState(() {
        _img = img;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    // 画面サイズを取得
    final Size size = MediaQuery.of(context).size;
    final double _width = size.width;
    final double _height = size.height;

    // レイダーチャートに表示するためのリストを作成
    _fetchListValue();
    // カッピングした日付をフォーマット
    _cuppedDateStr = DateFormat('yyyy-MM-dd').format(_cuppedDate).toString();

    return Scaffold(
        appBar: AppBar(
          title: Container(
            height: _height * 0.025,
            margin: EdgeInsets.fromLTRB(0, _height * 0.01, 0, 0),
            child: Image.asset('images/cuppers_logo_apart-05.png'),
          ),
          backgroundColor: Colors.white24,
          elevation: 0.0,
          leading: Container(
            height: _height * 0.025,
            margin: EdgeInsets.fromLTRB(0, _height * 0.01, 0, 0),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_sharp),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(_height * 0.08),
            child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, _width * 0.05, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        child: IconButton(
                            icon: _getThumbUpIcon(_isThumbUp),
                            onPressed: () {
                              _switchThumbUpIcon(_isThumbUp, widget.documentId, _uid);
                            }
                        )
                    ),
                  ],
                )
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, _height * 0.015, 0, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: HexColor('e7e7e7'),
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
                        margin: EdgeInsets.fromLTRB(_width * 0.1, _height * 0.03, _width * 0.1, 0),
                        child: Text(
                          _cuppedDateStr,
                          style: TextStyle(
                              fontSize: _height * 0.02
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(_width * 0.1, _height * 0.015, _width * 0.1, 0),
                        child: Text(
                          '$_coffeeName $_process $_variety',
                          style: TextStyle(
                              fontSize: _height * 0.035
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(_width * 0.1, _height * 0.015, _width * 0.1, 0),
                        child: Text(
                          'Elevation: ${_elevation}m',
                          style: TextStyle(
                              fontSize: _height * 0.02
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(_width * 0.1, _height * 0.015, _width * 0.1, 0),
                        child: Text(
                          'Made in $_country',
                          style: TextStyle(
                              fontSize: _height * 0.02
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(_width * 0.1, _height * 0.015, _width * 0.1, _height * 0.01),
                        child: Text(
                          'Roasted by $_roaster',
                          style: TextStyle(
                              fontSize: _height * 0.02
                          ),
                        ),
                      ),
                      Container(
                          width: _width * 0.8,
                          height: _height * 0.38,
                          child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Center(
                                  child: Container(
                                    child: RadarChart(
                                      graphColors: [HexColor('313131')],
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
                                      data: _chartValueList,
                                    ),
                                  )
                              )
                          )
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(_width * 0.65, 0, 0, 0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  'Score',
                                  style: TextStyle(
                                      fontSize: _height * 0.02
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  '$_coffeeScore',
                                  style: TextStyle(
                                      fontSize: _height * 0.05
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(_width * 0.1, _height * 0.03, _width * 0.1, 0),
                        child: Text(
                          'Flavor Text',
                          style: TextStyle(
                            fontSize: _height * 0.015,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(_width * 0.1, _height * 0.015, _width * 0.1, 0),
                        child: Text(
                          '$_flavorText',
                          style: TextStyle(
                              fontSize: _height * 0.02
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(_width * 0.1, _height * 0.03, 0, 0),
                        child: Text(
                            'Comment',
                            style: TextStyle(
                              fontSize: _height * 0.015,
                            )
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(_width * 0.1, _height * 0.015, _width * 0.1, _height * 0.05),
                        child: Text(
                          '$_comment',
                          style: TextStyle(
                              fontSize: _height * 0.02
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, _height * 0.03, 0, 0),
                        child: _userImageWidget(_width, _height),
                      ),
                      Container(
                        // width: double.infinity,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, _height * 0.1),
                        child: Text(
                            'Cupper is $_name',
                            style: TextStyle(
                              fontSize: _height * 0.03,
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
        )
    );
  }

  // カッピングデータを取得してメンバ変数に格納するメソッド
  void _fetchCuppingData(String uid, String documentId) async {

    setState(() {
      _coffeeName = widget.snapshot['coffee_name'];
      _country = widget.snapshot['country'];
      _variety = widget.snapshot['variety'];
      _elevation = widget.snapshot['elevation'].round(); // double型をint型に変換
      _process = widget.snapshot['process'];
      _roaster = widget.snapshot['roaster'];
      _cleanCup = widget.snapshot['cleancup'];
      _sweetness = widget.snapshot['sweetness'];
      _acidity = widget.snapshot['acidity'];
      _mouseFeel = widget.snapshot['mousefeel'];
      _flavor = widget.snapshot['flavor'];
      _afterTaste = widget.snapshot['aftertaste'];
      _balance = widget.snapshot['balance'];
      _overAll = widget.snapshot['overall'];
      _cuppedDate = widget.snapshot['cupped_date'].toDate();
      _coffeeScore = widget.snapshot['coffee_score'];
      _flavorText = widget.snapshot['flavor_text'];
      _comment = widget.snapshot['comment'];
      _cupperUid = widget.snapshot['uid'];

      if (widget.snapshot['thumbUp'] != null) {
        _thumbUp = widget.snapshot['thumbUp'];
      } else {
        _thumbUp = [];
      }

      _isThumbUp = _thumbUp.contains(uid);
    });
  }

  // TODO double型に対応していないため、int型に変換してしまっている
  // レイダーチャートに表示する型に詰め替えるメソッド
  void _fetchListValue() {

    List<int> valueList = [];
    valueList.add(_cleanCup.toInt());
    valueList.add(_sweetness.toInt());
    valueList.add(_acidity.toInt());
    valueList.add(_mouseFeel.toInt());
    valueList.add(_flavor.toInt());
    valueList.add(_afterTaste.toInt());
    valueList.add(_balance.toInt());
    valueList.add(_overAll.toInt());

    _chartValueList.add(valueList);
  }

  Widget _getThumbUpIcon(bool thumbUp) {

    if (thumbUp) {
      return Icon(Icons.thumb_up);
    } else {
      return Icon(Icons.thumb_up_outlined);
    }
  }

  // いいねフラグを更新するメソッド
  void _switchThumbUpIcon(bool thumbUp, String documentId, String uid) {

    if (!thumbUp) {

      // いいねリストにuidを追加
      _thumbUp.add(uid);

      FirebaseFirestore.instance
          .collection('TimelineCuppedCoffee')
          .doc(documentId)
          .update({'thumbUp': _thumbUp});

      setState(() {
        _isThumbUp = true;
      });

    } else {

      // いいねリストからuidを削除
      _thumbUp.removeAt(_thumbUp.indexOf(uid));

      FirebaseFirestore.instance
          .collection('TimelineCuppedCoffee')
          .doc(documentId)
          .update({'thumbUp': _thumbUp});

      setState(() {
        _isThumbUp = false;
      });

    }
  }

  Widget _userImageWidget(double width, double height) {

    if (_img != null) {

      return Container(
        width: width * 0.45,
        height: height * 0.3,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.cover,
                image: _img.image
            )
        ),
      );
    } else {

      return Container(
          width: width * 0.45,
          height: height * 0.3,
          decoration: BoxDecoration(
            border: Border.all(color: HexColor('313131')),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '画像を選択してください',
              style: TextStyle(
                  color: HexColor('313131')
              ),
            ),
          )
      );
    }
  }

  // ユーザーネームを取得するメソッド
  Future _getUserName() async {

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(this._cupperUid)
        .get();

    setState(() {
      if (snapshot.data()['name'] != null) {
        _name = snapshot.data()['name'];
      } else {
        _name = 'Unknown';
      }
    });
  }
}
