import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './views/RegistrationPage.dart';
import './views/LoginPage.dart';
import './views/CoffeeIndexPage.dart';
import './views/CuppingPage.dart';
import './views/FavoriteListPage.dart';

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
        // '/': (_) => new Splash(),
        '/home': (_) => new HomePage(), // ベースになる画面
        '/login': (_) => new LoginPage(), // ログイン画面
        '/registration': (_) => new RegistrationPage(), // アカウント登録画面
      },
      home: _checkCurrentUser()
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
