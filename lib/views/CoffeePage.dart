import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuppers_mobile/services/HexColor.dart';
import 'package:cuppers_mobile/views/RegistrationPage.dart';
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
  bool _isPublic;

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
                    icon: _getPublicIcon(),
                    onPressed: () {

                      if (FirebaseAuth.instance.currentUser.isAnonymous) {

                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                content: Text('ユーザー登録をしてカッピングしたコーヒーを公開しましょう'),
                                actions: <Widget>[
                                  // ボタン領域
                                  ElevatedButton(
                                    child: Text('今はしない'),
                                    style: ElevatedButton.styleFrom(
                                      primary: HexColor('313131'),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  ElevatedButton(
                                    child: Text('ユーザー登録'),
                                    style: ElevatedButton.styleFrom(
                                      primary: HexColor('313131'),
                                    ),
                                    onPressed: () {

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => RegistrationPage()
                                          )
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                        );
                      } else {

                        if (_isPublic) {

                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                content: Text('このカッピングデータを非公開にしますか？'),
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
                                      onPressed: () async {

                                        _deleteCuppingDataToPublicCollection(widget.documentId);
                                        _switchPublicSetting(this._isPublic, widget.documentId, this._uid);
                                        Navigator.pop(context);
                                      }
                                  ),
                                ],
                              );
                            },
                          );
                        } else {

                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                content: Text('このカッピングデータを公開しますか？'),
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

                                      _addCuppingDataToPublicCollection(widget.snapshot, widget.documentId, this._uid);
                                      _switchPublicSetting(this._isPublic, widget.documentId, this._uid);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
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
                    margin: EdgeInsets.fromLTRB(_width * 0.1, _height * 0.015, _width * 0.1, _height * 0.1),
                    child: Text(
                      '$_comment',
                      style: TextStyle(
                          fontSize: _height * 0.02
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

      // 後付け機能のためトランザクションが起きないようにする
      if (widget.snapshot['public'] != null) {
        _isPublic = widget.snapshot['public'];
      } else {
        _isPublic = false;
      }
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

  // 公開設定をを更新するメソッド
  void _switchPublicSetting(bool public, String documentId, String uid) async {

    if (public) {

      // データを更新
      await FirebaseFirestore.instance
          .collection('CuppedCoffee')
          .doc(uid)
          .collection('CoffeeInfo')
          .doc(documentId)
          .update({'public': false});

      // ステートの値を変更
      setState(() {
        _isPublic = false;
      });

    } else {

      // データを更新
      await FirebaseFirestore.instance
          .collection('CuppedCoffee')
          .doc(uid)
          .collection('CoffeeInfo')
          .doc(documentId)
          .update({'public': true});

      // ステートの値を変更
      setState(() {
        _isPublic = true;
      });

    }
  }

  // 公開専用のカッピングデータを格納するコレクションにデータを追加するメソッド
  void _addCuppingDataToPublicCollection(Map<String, dynamic> cuppingData, String documentId, String uid) async {

    cuppingData['uid'] = uid;

    final _ref = FirebaseFirestore.instance.collection('TimelineCuppedCoffee');

    Future<DocumentSnapshot> snapshot = _ref.doc(documentId).get();
    if (snapshot != null) {
      _ref.doc(documentId).set(cuppingData);
    }
  }

  // 公開専用のカッピングデータを格納するコレクションからデータを削除するメソッド
  void _deleteCuppingDataToPublicCollection(String documentId) async {

    final _ref = FirebaseFirestore.instance.collection('TimelineCuppedCoffee');

    Future<DocumentSnapshot> snapshot = _ref.doc(documentId).get();
    if (snapshot != null) {
      _ref.doc(documentId).delete();
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

  // カッピングデータの公開設定を判定してアイコンを返却するメソッド
  Icon _getPublicIcon() {

    if (!_isPublic) {
      return Icon(Icons.public_off);
    } else {
      return Icon(Icons.public);
    }
  }
}
