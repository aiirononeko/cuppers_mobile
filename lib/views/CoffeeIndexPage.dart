import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  // 検索機能で使用する変数
  // TODO Algoliaを使って実装する必要がありそうなので後回し
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
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 150,
                  height: 35,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Search',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchValue = value;
                      });
                    },
                  ),
                ),
                Container(
                  width: 150,
                  height: 35,
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
            _buildBody()
          ],
        )
      )
    );
  }

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

    return StreamBuilder<QuerySnapshot>(  // Streamを監視して、イベントが通知される度にWidgetを更新する
      stream: FirebaseFirestore.instance
          .collection('CuppedCoffee')
          .doc(this._uid)
          .collection('CoffeeInfo')
          .orderBy('cupped_date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text('Loading...');
        return _buildList(snapshot.data.docs);
      },
    );
  }

  // スコア順に表示する
  Widget _buildBodyScore() {

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

  // お気に入りのコーヒーのみ表示する
  Widget _buildBodyFavoriteCoffee() {

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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical:9.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CoffeePage(snap.id)
                )
            );
          },
          leading: Icon(
            _checkFavoriteFlag(data),
            size: 35,
          ),
          title: Text(data["coffee_name"]),
          subtitle: Text("made in " + data["country"]),
          trailing: Text("Score " + data["coffee_score"].toString()),
          isThreeLine: true,
        ),
      ),
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
