import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Cuppers",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

// マイページ
class _MyHomePageState extends State<MyHomePage> {

  final String params = 'bSToUcjAUQU3B698byZ9'; // ドキュメントID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cuppers")),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<QuerySnapshot>(  // Streamを監視して、イベントが通知される度にWidgetを更新する
      stream: FirebaseFirestore.instance.collection("coffee").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
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
          title: Text(data["name"]),
          subtitle: Text("made in " + data["farmer"]),
          trailing: Text("Score " + data["score"].toString()),
          // isThreeLine: true,
          // firestoreのtimestampを表示する方法↓
          // data["timestamp"].toDate().toString()
        ),
      ),
    );
  }
}

// カッピング情報詳細画面
class CoffeePage extends StatefulWidget {

  @override
  _CoffeePageState createState() {
    return _CoffeePageState();
  }
}

class _CoffeePageState extends State<CoffeePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cuppers")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('coffee').document('bSToUcjAUQU3B698byZ9').snapshots(),
        builder: (context, snapshot) {
          return Text(snapshot.data["name"]);
        },
      ),
    );
  }
}
