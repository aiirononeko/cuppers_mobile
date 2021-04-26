import 'package:cuppers_mobile/views/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// アカウント情報表示画面
class AccountInfoPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Center(
            child: SizedBox(
              width: 250,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: HexColor('e7e7e7'),
                ),
                child: Text(
                  'ログアウト',
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 25,
                  ),
                ),
                onPressed: () async {

                  // サインアウト
                  await FirebaseAuth.instance.signOut();

                  Navigator.pushAndRemoveUntil(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new LoginPage()),
                          (_) => false);
                },
              ),
            )
          )
        )
    );
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
