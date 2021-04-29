import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './CoffeePage.dart';

// カッピングしたコーヒーを一覧表示するページ
class CoffeeIndexPage extends StatefulWidget {

  @override
  _CoffeeIndexPageState createState() {
    return _CoffeeIndexPageState();
  }
}

class _CoffeeIndexPageState extends State<CoffeeIndexPage> {

  List<DropdownMenuItem<int>> _items = [];
  int _selectItem = 1;

  // ユーザーが検索ボックスを使用しているか否かを判定する変数
  bool _userUseSearchFunc = false;

  // 検索ボックスに入力された文字列を格納する変数
  String _searchValue = '';

  @override
  void initState() {
    super.initState();
    setItems();
    _selectItem = _items[0].value;
  }

  void setItems() {
    _items
      ..add(DropdownMenuItem(
        child: Text('作成日'),
        value: 1,
      ))
      ..add(DropdownMenuItem(
        child: Text('評価が高い'),
        value: 2,
      ))
      ..add(DropdownMenuItem(
        child: Text('お気に入り'),
        value: 3,
      ));
  }

  String _uid = '';

  @override
  Widget build(BuildContext context) {

    // ログイン中のユーザーIDを取得
    _uid = FirebaseAuth.instance.currentUser.uid;

    return Scaffold(
      floatingActionButton: Column(
        verticalDirection: VerticalDirection.up, // childrenの先頭を下に配置
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            backgroundColor: Colors.grey,
            onPressed: () {
              Navigator.pushNamed(context, '/cupping');
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 35,
                    margin: EdgeInsets.fromLTRB(50, 0, 0, 0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Search',
                      ),
                      onChanged: (value) {
                        if (value != '') {
                          setState(() {
                            _searchValue = value;
                            _userUseSearchFunc = true;
                          });
                        } else {
                          setState(() {
                            _searchValue = value;
                            _userUseSearchFunc = false;
                          });
                        }
                      },
                    ),
                  ),
                  Container(
                    width: 105,
                    height: 40,
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: DropdownButton(
                      items: _items,
                      value: _selectItem,
                      onChanged: (value) => {
                        setState(() {
                          _selectItem = value;
                        }),
                      },
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Divider(
                  color: Colors.black,
                ),
              ),
              _buildBody(),
            ],
          )
        )
      )
    );
  }

  // ボディを作成する親クラス
  Widget _buildBody() {

    if (_selectItem == 1) {
      return _buildBodyCreatedAt();
    } else if (_selectItem == 2) {
      return _buildBodyScore();
    }
    return _buildBodyFavoriteCoffee();
  }

  // 作成日順で表示する
  Widget _buildBodyCreatedAt() {

    if (_userUseSearchFunc == false) {
      return StreamBuilder<QuerySnapshot>(  // Streamを監視して、イベントが通知される度にWidgetを更新する
        stream: FirebaseFirestore.instance
            .collection('CuppedCoffee')
            .doc(this._uid)
            .collection('CoffeeInfo')
            .orderBy('cupped_date', descending: true)
        // .where('coffee_name', isEqualTo: 'Some Coffee')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading...');
          return _buildList(snapshot.data.docs);
        },
      );
    }

    // 検索ボックスを使用している場合は検索された文字列のデータを表示する
    return StreamBuilder<QuerySnapshot>(  // Streamを監視して、イベントが通知される度にWidgetを更新する
      stream: FirebaseFirestore.instance
          .collection('CuppedCoffee')
          .doc(this._uid)
          .collection('CoffeeInfo')
          .where('coffee_name', isEqualTo: this._searchValue)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text('Loading...');
        return _buildList(snapshot.data.docs);
      },
    );
  }

  // スコア順に表示する
  Widget _buildBodyScore() {

    if (_userUseSearchFunc == false) {
      return StreamBuilder<QuerySnapshot>(  // Streamを監視して、イベントが通知される度にWidgetを更新する
        stream: FirebaseFirestore.instance
            .collection('CuppedCoffee')
            .doc(this._uid)
            .collection('CoffeeInfo')
            .orderBy('coffee_score', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading...');
          return _buildList(snapshot.data.docs);
        },
      );
    }

    // 検索ボックスを使用している場合は検索された文字列のデータを表示する
    return StreamBuilder<QuerySnapshot>(  // Streamを監視して、イベントが通知される度にWidgetを更新する
      stream: FirebaseFirestore.instance
          .collection('CuppedCoffee')
          .doc(this._uid)
          .collection('CoffeeInfo')
          .where('coffee_name', isEqualTo: this._searchValue)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text('Loading...');
        return _buildList(snapshot.data.docs);
      },
    );
  }

  // お気に入りのコーヒーのみ表示する
  Widget _buildBodyFavoriteCoffee() {

    if (_userUseSearchFunc == false) {
      return StreamBuilder<QuerySnapshot>(  // Streamを監視して、イベントが通知される度にWidgetを更新する
        stream: FirebaseFirestore.instance
            .collection('CuppedCoffee')
            .doc(this._uid)
            .collection('CoffeeInfo')
            .where('favorite', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading...');
          return _buildList(snapshot.data.docs);
        },
      );
    }

    // 検索ボックスを使用している場合は検索された文字列のデータを表示する
    return StreamBuilder<QuerySnapshot>(  // Streamを監視して、イベントが通知される度にWidgetを更新する
      stream: FirebaseFirestore.instance
          .collection('CuppedCoffee')
          .doc(this._uid)
          .collection('CoffeeInfo')
          .where('coffee_name', isEqualTo: this._searchValue)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text('Loading...');
        return _buildList(snapshot.data.docs);
      },
    );
  }

  Widget _buildList(List<DocumentSnapshot> snapList) {

    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(18.0),
        itemCount: snapList.length,
        itemBuilder: (context, i) {
          return _buildListItem(snapList[i]);
        }
    );
  }

  Widget _buildListItem(DocumentSnapshot snap) {

    Map<String, dynamic> data = snap.data();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoffeePage(snap.id)
          )
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Container(
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
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(20, 30, 10, 30),
                child: Icon(
                  _checkFavoriteFlag(data),
                  size: 30,
                )
              ),
              Container(
                width: 220,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          DateFormat('yyyy-MM-dd').format(data['cupped_date'].toDate()).toString(),
                          style: TextStyle(
                              fontSize: 10
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text(
                          data['coffee_name'],
                          style: TextStyle(
                              fontSize: 20
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text(
                          'made in ${data['country']}',
                          style: TextStyle(
                              fontSize: 15
                          ),
                        ),
                      )
                    ]
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Column(
                  children: <Widget>[
                    Container(
                        child: Text(
                            'Score'
                        )
                    ),
                    Container(
                        child: Text(
                          data['coffee_score'].toString(),
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      )
    );
  }

  // お気に入りかどうかを判定してアイコンを変更するメソッド
  IconData _checkFavoriteFlag(Map<String, dynamic> data) {
    if (data['favorite']) {
      return Icons.star;
    } else {
      return Icons.star_border;
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
