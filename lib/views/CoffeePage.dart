import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import 'EditingCoffeePage.dart';

// カッピング情報詳細画面
class CoffeePage extends StatefulWidget {

  final Map<String, dynamic> snapshot;
  final String documentId;
  CoffeePage(this.snapshot, this.documentId);

  @override
  _CoffeePageState createState() => _CoffeePageState();
}

class _CoffeePageState extends State<CoffeePage> {

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
  bool _favorite;
  double _coffeeScore;
  String _flavorText;
  String _comment;

  List<List<int>> _chartValueList = [];

  String _cuppedDateStr = '';

  @override
  void initState() {
    super.initState();

    // ログイン中のユーザーIDを取得
    _uid = FirebaseAuth.instance.currentUser.uid;
    // カッピング情報をステートに保存
    _fetchCuppingData(_uid, widget.documentId);
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
        backgroundColor: Colors.white24,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Container(
          margin: EdgeInsets.fromLTRB(0, _height / 30, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios_sharp,
                      color: HexColor('313131'),
                      size: _width / 16,
                    ),
                  ),
                  Container(
                    width: _width / 2.4,
                    margin: EdgeInsets.fromLTRB(_width / 8, _height / 22, _width / 8, _height / 22),
                    child: Image.asset('images/cuppers_logo_apart-05.png'),
                  )
                ],
              ),
            ],
          )
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Container(
            margin: EdgeInsets.fromLTRB(0, _height / 40, _width / 26, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: IconButton(
                    icon: Icon(Icons.ios_share),
                    onPressed: () {

                      // TODO 本実装
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            content: Text('シェア機能は開発中です。実装完了まで今しばらくお待ちください。'),
                            actions: <Widget>[
                              ElevatedButton(
                                child: Text('OK'),
                                style: ElevatedButton.styleFrom(
                                  primary: HexColor('313131'),
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          );
                        },
                      );

                    },
                  ),
                ),
                Container(
                    child: IconButton(
                        icon: _getFavoriteFlag(_favorite),
                        onPressed: () {
                          _switchFavoriteFlag(_favorite, widget.documentId, _uid);
                        }
                    )
                ),
                Container(
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditingCoffeePage(widget.snapshot, widget.documentId)
                          )
                      );

                    },
                  ),
                ),
                Container(
                  child: IconButton(
                    icon: Icon(Icons.delete_outline_sharp),
                    onPressed: () {

                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            content: Text('カッピング情報を削除しますか？'),
                            actions: <Widget>[
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

                                  // カッピングデータを削除
                                  FirebaseFirestore.instance
                                      .collection('CuppedCoffee')
                                      .doc(_uid)
                                      .collection('CoffeeInfo')
                                      .doc(widget.documentId)
                                      .delete();

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
                  )
                )
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
              margin: EdgeInsets.fromLTRB(0, _height / 180, 0, 0),
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
                    margin: EdgeInsets.fromLTRB(_width / 12, _height / 44, 0, 0),
                    child: Text(
                      _cuppedDateStr,
                      style: TextStyle(
                          fontSize: 16
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(_width / 12, _width / 40, 0, 0),
                    child: Text(
                      '$_coffeeName $_process $_variety',
                      style: TextStyle(
                          fontSize: 30
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(_width / 12, _width / 30, 0, 0),
                    child: Text(
                      'Elevation: ${_elevation}m',
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(_width / 12, _width / 40, 0, 0),
                    child: Text(
                      'Made in $_country',
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(_width / 12, _width / 40, 0, 0),
                    child: Text(
                      'Roasted by $_roaster',
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
                      margin: EdgeInsets.fromLTRB(_width / 1.8, 0, 0, 0),
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
                              '$_coffeeScore',
                              style: TextStyle(
                                  fontSize: 40
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(_width / 12, _width / 10, 0, 0),
                    child: Text(
                      'フレーバーテキスト',
                      style: TextStyle(
                        fontSize: _width / 24,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(_width / 12, _width / 40, _width / 80, 0),
                    child: Text(
                      '$_flavorText',
                      style: TextStyle(
                        fontSize: _width / 20
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(_width / 12, _width / 12, 0, 0),
                    child: Text(
                      'カッピングコメント',
                      style: TextStyle(
                        fontSize: _width / 24,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(_width / 12, _width / 40, _width / 16, _height / 14),
                    child: Text(
                      '$_comment',
                      style: TextStyle(
                          fontSize: _width / 20
                      ),
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
      _favorite = widget.snapshot['favorite'];
      _coffeeScore = widget.snapshot['coffee_score'];
      _flavorText = widget.snapshot['flavor_text'];
      _comment = widget.snapshot['comment'];
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

  // お気に入りフラグを更新するメソッド
  void _switchFavoriteFlag(bool favorite, String documentId, String uid) {

    if (favorite) {
      FirebaseFirestore.instance
          .collection('CuppedCoffee')
          .doc(uid)
          .collection('CoffeeInfo')
          .doc(documentId)
          .update({'favorite': false});

      setState(() {
        _favorite = false;
      });

    } else {
      FirebaseFirestore.instance
          .collection('CuppedCoffee')
          .doc(uid)
          .collection('CoffeeInfo')
          .doc(documentId)
          .update({'favorite': true});

      setState(() {
        _favorite = true;
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
