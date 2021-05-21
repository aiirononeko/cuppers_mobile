import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuppers_mobile/services/HexColor.dart';
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

  String _uid;

  @override
  Widget build(BuildContext context) {

    // ログイン中のユーザーIDを取得
    _uid = FirebaseAuth.instance.currentUser.uid;

    // 画面サイズを取得
    final Size size = MediaQuery.of(context).size;
    final _width = size.width;
    final _height = size.height;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Container(
              height: _height * 0.025,
              margin: EdgeInsets.fromLTRB(0, _height * 0.01, 0, 0),
              child: Image.asset('images/cuppers_logo_apart-05.png'),
            )
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(_height * 0.08),
          child:  AppBar(
            title: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: _width * 0.35,
                      height: _height * 0.035,
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
                      width: _width * 0.1,
                    ),
                    Container(
                      height: _height * 0.05,
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
              ],
            ),
            backgroundColor: Colors.white24,
            elevation: 0.0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white24,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      floatingActionButton: Column(
        verticalDirection: VerticalDirection.up, // childrenの先頭を下に配置
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            backgroundColor: HexColor('313131'),
            onPressed: () {
              Navigator.pushNamed(context, '/cupping');
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                child: Divider(
                  color: HexColor('313131'),
                ),
              ),
              _buildBody(_width, _height),
            ],
          )
        )
      )
    );
  }

  // ボディを作成する親クラス
  Widget _buildBody(double width, double height) {

    if (_selectItem == 1) {
      return _buildBodyCreatedAt(width, height);
    } else if (_selectItem == 2) {
      return _buildBodyScore(width, height);
    }
    return _buildBodyFavoriteCoffee(width, height);
  }

  // 作成日順で表示する
  Widget _buildBodyCreatedAt(double width, double height) {

    if (_userUseSearchFunc == false) {
      return StreamBuilder<QuerySnapshot>(  // Streamを監視して、イベントが通知される度にWidgetを更新する
        stream: FirebaseFirestore.instance
            .collection('CuppedCoffee')
            .doc(this._uid)
            .collection('CoffeeInfo')
            .orderBy('cupped_date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {

            return Container(
              height: height * 0.65,
              alignment: Alignment.center,
              child: Text(
                'Loading ...',
                style: TextStyle(
                    fontSize: height * 0.02,
                    color: HexColor('313131')
                ),
              ),
            );
          }

          // カッピングしたコーヒーがなかった場合
          if (snapshot.data.docs.length == 0) {

            return Container(
              height: height * 0.65,
              alignment: Alignment.center,
              child: Text(
                  'カッピングしたコーヒーはありません',
                style: TextStyle(
                  fontSize: height * 0.02,
                  color: HexColor('313131')
                ),
              ),
            );
          }
          return _buildList(snapshot.data.docs, width, height);
        },
      );
    }

    // 検索ボックスを使用している場合は検索された文字列のデータを表示する
    return StreamBuilder<QuerySnapshot>(  // Streamを監視して、イベントが通知される度にWidgetを更新する
      stream: FirebaseFirestore.instance
          .collection('CuppedCoffee')
          .doc(this._uid)
          .collection('CoffeeInfo')
          .orderBy('coffee_name')
          .startAt([this._searchValue])
          .endAt([this._searchValue + '\uf8ff'])
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {

          return Container(
            height: height * 0.65,
            alignment: Alignment.center,
            child: Text(
              'Loading ...',
              style: TextStyle(
                  fontSize: height * 0.02,
                  color: HexColor('313131')
              ),
            ),
          );
        }

        // カッピングしたコーヒーがなかった場合
        if (snapshot.data.docs.length == 0) {

          return Container(
            height: height * 0.65,
            alignment: Alignment.center,
            child: Text(
              '検索されたコーヒーはありません',
              style: TextStyle(
                  fontSize: height * 0.02,
                  color: HexColor('313131')
              ),
            ),
          );
        }
        return _buildList(snapshot.data.docs, width, height);
      },
    );
  }

  // スコア順に表示する
  Widget _buildBodyScore(double width, double height) {

    if (_userUseSearchFunc == false) {
      return StreamBuilder<QuerySnapshot>(  // Streamを監視して、イベントが通知される度にWidgetを更新する
        stream: FirebaseFirestore.instance
            .collection('CuppedCoffee')
            .doc(this._uid)
            .collection('CoffeeInfo')
            .orderBy('coffee_score', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {

            return Container(
              height: height * 0.65,
              alignment: Alignment.center,
              child: Text(
                'Loading ...',
                style: TextStyle(
                    fontSize: height * 0.02,
                    color: HexColor('313131')
                ),
              ),
            );
          }

          // カッピングしたコーヒーがなかった場合
          if (snapshot.data.docs.length == 0) {

            return Container(
              height: height * 0.65,
              alignment: Alignment.center,
              child: Text(
                'カッピングしたコーヒーはありません',
                style: TextStyle(
                    fontSize: height * 0.02,
                    color: HexColor('313131')
                ),
              ),
            );
          }
          return _buildList(snapshot.data.docs, width, height);
        },
      );
    }

    // 検索ボックスを使用している場合は検索された文字列のデータを表示する
    return StreamBuilder<QuerySnapshot>(  // Streamを監視して、イベントが通知される度にWidgetを更新する
      stream: FirebaseFirestore.instance
          .collection('CuppedCoffee')
          .doc(this._uid)
          .collection('CoffeeInfo')
          .orderBy('coffee_name')
          .startAt([this._searchValue])
          .endAt([this._searchValue + '\uf8ff'])
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {

          return Container(
            height: height * 0.65,
            alignment: Alignment.center,
            child: Text(
              'Loading ...',
              style: TextStyle(
                  fontSize: height * 0.02,
                  color: HexColor('313131')
              ),
            ),
          );
        }

        // カッピングしたコーヒーがなかった場合
        if (snapshot.data.docs.length == 0) {

          return Container(
            height: height * 0.65,
            alignment: Alignment.center,
            child: Text(
              '検索されたコーヒーはありません',
              style: TextStyle(
                  fontSize: height * 0.02,
                  color: HexColor('313131')
              ),
            ),
          );
        }
        return _buildList(snapshot.data.docs, width, height);
      },
    );
  }

  // お気に入りのコーヒーのみ表示する
  Widget _buildBodyFavoriteCoffee(double width, height) {

    if (_userUseSearchFunc == false) {
      return StreamBuilder<QuerySnapshot>(  // Streamを監視して、イベントが通知される度にWidgetを更新する
        stream: FirebaseFirestore.instance
            .collection('CuppedCoffee')
            .doc(this._uid)
            .collection('CoffeeInfo')
            .where('favorite', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {

            return Container(
              height: height * 0.65,
              alignment: Alignment.center,
              child: Text(
                'Loading ...',
                style: TextStyle(
                    fontSize: height * 0.02,
                    color: HexColor('313131')
                ),
              ),
            );
          }

          // カッピングしたコーヒーがなかった場合
          if (snapshot.data.docs.length == 0) {

            return Container(
              height: height * 0.65,
              alignment: Alignment.center,
              child: Text(
                'お気に入りのコーヒーはありません',
                style: TextStyle(
                    fontSize: height * 0.02,
                    color: HexColor('313131')
                ),
              ),
            );
          }
          return _buildList(snapshot.data.docs, width, height);
        },
      );
    }

    // 検索ボックスを使用している場合は検索された文字列のデータを表示する
    return StreamBuilder<QuerySnapshot>(  // Streamを監視して、イベントが通知される度にWidgetを更新する
      stream: FirebaseFirestore.instance
          .collection('CuppedCoffee')
          .doc(this._uid)
          .collection('CoffeeInfo')
          .orderBy('coffee_name')
          .startAt([this._searchValue])
          .endAt([this._searchValue + '\uf8ff'])
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {

          return Container(
            height: height * 0.65,
            alignment: Alignment.center,
            child: Text(
              'Loading ...',
              style: TextStyle(
                  fontSize: height * 0.02,
                  color: HexColor('313131')
              ),
            ),
          );
        }

        // カッピングしたコーヒーがなかった場合
        if (snapshot.data.docs.length == 0) {

          return Container(
            height: height * 0.65,
            alignment: Alignment.center,
            child: Text(
              '検索されたコーヒーはありません',
              style: TextStyle(
                  fontSize: height * 0.02,
                  color: HexColor('313131')
              ),
            ),
          );
        }
        return _buildList(snapshot.data.docs, width, height);
      },
    );
  }

  Widget _buildList(List<DocumentSnapshot> snapList, double width, double height) {

    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(width * 0.015, 0, width * 0.015, 0),
        itemCount: snapList.length,
        itemBuilder: (context, i) {
          return _buildListItem(snapList[i], width, height);
        }
    );
  }

  Widget _buildListItem(DocumentSnapshot snap, double width, double height) {

    Map<String, dynamic> data = snap.data();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoffeePage(data, snap.id)
          )
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, height * 0.02, 0, 0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height * 0.01),
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Icon(
                  _checkFavoriteFlag(data),
                  size: height * 0.03,
                )
              ),
              Container(
                width: width * 0.65,
                margin: EdgeInsets.fromLTRB(0, height * 0.015, 0, height * 0.015),
                child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.005),
                        child: Text(
                          DateFormat('yyyy-MM-dd').format(data['cupped_date'].toDate()).toString(),
                          style: TextStyle(
                            fontSize: height * 0.013,
                            color: HexColor('313131')
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, height * 0.001, 0, height * 0.005),
                        child: Text(
                          data['coffee_name'],
                          style: TextStyle(
                            fontSize: height * 0.03,
                            color: HexColor('313131')
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.001),
                        child: Text(
                          'made in ${data['country']}',
                          style: TextStyle(
                            fontSize: height * 0.018,
                            color: HexColor('313131')
                          ),
                        ),
                      )
                    ]
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.005),
                        child: Text(
                          'Score',
                          style: TextStyle(
                            color: HexColor('313131'),
                            fontSize: height * 0.015,
                          ),
                        )
                    ),
                    Container(
                        child: Text(
                          data['coffee_score'].toString(),
                          style: TextStyle(
                            fontSize: height * 0.03,
                            color: HexColor('313131')
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
