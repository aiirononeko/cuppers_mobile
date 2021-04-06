import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import './views/CoffeeIndexPage.dart';
import './views/CuppingPage.dart';
import './views/FavoriteListPage.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cuppers',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 表示中の Widget を取り出すための index としての int 型の mutable な stored property
  int _selectedIndex = 0;

  // 表示する Widget の一覧
  static List<Widget> _pageList = [
    CoffeeIndexPage(),
    CuppingPage(),
    FavoriteListPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cuppers")),
      body: _pageList[_selectedIndex],
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // タップ時の処理
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
