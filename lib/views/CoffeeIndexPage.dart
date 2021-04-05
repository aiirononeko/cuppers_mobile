import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import './CoffeePage.dart';

// カッピングしたコーヒーを一覧表示するページ
class CoffeeIndexPage extends StatefulWidget {

  @override
  _CoffeeIndexPageState createState() {
    return _CoffeeIndexPageState();
  }
}

class _CoffeeIndexPageState extends State<CoffeeIndexPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cuppers")),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_cafe_outlined),
            label: 'Cupping',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border_outlined),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {

    return StreamBuilder<QuerySnapshot>(  // Streamを監視して、イベントが通知される度にWidgetを更新する
      stream: FirebaseFirestore.instance
          .collection('CuppedCoffee')
          .doc('VjiipudVwojp7B1WWrWH')
          .collection('CoffeeInfo')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text('Loading...');
        return _buildList(snapshot.data.docs);
      },
    );
  }

  Widget _buildList(List<DocumentSnapshot> snapList) {

    return ListView.builder(
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
          onTap: () =>
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => CoffeePage()
                  )
              ),
          leading: Icon(
            Icons.star_border,
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
}
