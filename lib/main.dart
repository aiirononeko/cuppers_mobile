import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './views/RegistrationPage.dart';
import './views/LoginPage.dart';
import './views/CoffeeIndexPage.dart';
import './views/CuppingPage.dart';
import './views/TimelinePage.dart';
import './views/AccountInfoPage.dart';
import './services/MyFirebaseAuth.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 初回起動時(未ログイン)の場合
  if (FirebaseAuth.instance.currentUser == null) {
    // 匿名ユーザーとしてログイン
    await MyFirebaseAuth.createAnonymousUserAndLogin();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cuppers',
      routes: <String, WidgetBuilder>{
        '/home': (_) => new HomePage(), // ベースになる画面
        '/login': (_) => new LoginPage(), // ログイン画面
        '/registration': (_) => new RegistrationPage(), // アカウント登録画面
        '/cupping': (_) => new CuppingPage(), // カッピング画面
      },
      home: HomePage(),
      debugShowCheckedModeBanner: false
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  // 表示中のWidgetを取り出すためのindex
  int _selectedIndex = 0;

  // 表示するWidgetの一覧
  static List<Widget> _pageList = [
    CoffeeIndexPage(),
    TimelinePage(),
    AccountInfoPage()
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _pageList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer_sharp),
            label: 'SNS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Account',
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
