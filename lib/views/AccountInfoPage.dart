import 'package:cuppers_mobile/views/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'RegistrationPage.dart';

// アカウント情報表示画面
class AccountInfoPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // 画面サイズを取得
    final Size size = MediaQuery.of(context).size;
    final double _width = size.width;
    final double _height = size.height;

    return Scaffold(
        appBar: AppBar(
          title: Container(
            height: _height * 0.025,
            margin: EdgeInsets.fromLTRB(0, _height * 0.01, 0, 0),
            child: Image.asset('images/cuppers_logo_apart-05.png'),
          ),
          backgroundColor: Colors.white24,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
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
                      ),
                      Container(
                        width: _width * 0.1,
                      ),
                      Container(
                        height: _height * 0.05,
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
        ),
        body: _accountPage(_width, _height, context),
    );
  }

  Widget _accountPage(double width, double height, BuildContext context) {

    // ユーザーが匿名ユーザーか否かを判定
    if (FirebaseAuth.instance.currentUser.isAnonymous) {

      // 匿名ユーザーの場合
      return Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Divider(
                color: HexColor('313131'),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(width * 0.05, height * 0.015, 0, height * 0.015),
              child: Text(
                'アカウント',
                style: TextStyle(
                  fontSize: height * 0.013
                ),
              ),
            ),
            InkWell(
              onTap: () {

                // ユーザー登録画面に遷移
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrationPage()
                    )
                );
              },
              child: Container(
                width: width,
                height: height * 0.06,
                color: HexColor('e7e7e7'),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.05, 0, 0, 0),
                      child: Text(
                        'ユーザー登録',
                        style: TextStyle(
                            fontSize: height * 0.015
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.63, 0, 0, 0),
                      child: Icon(Icons.navigate_next),
                    )
                  ],
                )
              ),
            )
          ],
        )
      );
    } else {

      // 匿名ユーザーでない場合
      return Container(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Divider(
                  color: HexColor('313131'),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(width * 0.05, height * 0.015, 0, height * 0.015),
                child: Text(
                  'アカウント',
                  style: TextStyle(
                      fontSize: height * 0.013
                  ),
                ),
              ),
              InkWell(
                onTap: () async {

                  // サインアウト
                  await FirebaseAuth.instance.signOut();

                  // ログインページに遷移
                  Navigator.pushAndRemoveUntil(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new LoginPage()),
                          (_) => false);
                },
                child: Container(
                    width: width,
                    height: height * 0.06,
                    color: HexColor('e7e7e7'),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(width * 0.05, 0, 0, 0),
                          child: Text(
                            'ログアウト',
                            style: TextStyle(
                                fontSize: height * 0.015
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(width * 0.63, 0, 0, 0),
                          child: Icon(Icons.navigate_next),
                        )
                      ],
                    )
                ),
              )
            ],
          )
      );
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
