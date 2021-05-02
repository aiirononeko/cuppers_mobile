import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './views/RegistrationPage.dart';
import './views/LoginPage.dart';
import './views/CoffeeIndexPage.dart';
import './views/CuppingPage.dart';
import './views/AccountInfoPage.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
      home: _checkCurrentUser(),
      debugShowCheckedModeBanner: false
    );
  }
}

// ログイン状態をチェックして表示を切り替え
StatefulWidget _checkCurrentUser() {

  User user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return LoginPage();
  } else {
    return HomePage();
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
    AccountInfoPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cuppers',
          style: TextStyle(
              color: HexColor('313131'),
              fontSize: 25
          ),
        ),
        backgroundColor: Colors.white24,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: _pageList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: '',
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

// カラーコードで色を表示するためのサービスクラス
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
