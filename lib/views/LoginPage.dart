import 'package:cuppers_mobile/views/RegistrationPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:cuppers_mobile/services/MyFirebaseAuth.dart';

// ログインページ
class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String _email = '';
  String _password = '';

  final _formKey = GlobalKey<FormState>();

  // FirebaseAuthの処理を記述したサービスクラス
  MyFirebaseAuth _myFirebaseAuth = new MyFirebaseAuth();

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
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(_width * 0.1, _height * 0.15, _width * 0.1, _height * 0.08),
                child: Text(
                  'ログインしましょう',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: _height * 0.025,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.fromLTRB(_width * 0.1, 0, _width * 0.1, _height * 0.05),
                          child: TextFormField(
                            enabled: true,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.email),
                              hintText: 'example@xxx.com',
                              labelText: 'Email',
                            ),
                            style: TextStyle(
                              fontSize: _height * 0.02
                            ),
                            onChanged: _handleEmail,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'メールアドレスを入力してください';
                              }
                              if (!RegExp(r'[\w\-\._]+@[\w\-\._]+\.[A-Za-z]+').hasMatch(value)) {
                                return 'メールアドレスが正しくありません';
                              }
                              return null;
                            },
                          )
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(_width * 0.1, 0, _width * 0.1, _height * 0.08),
                          child: TextFormField(
                            enabled: true,
                            obscureText: true,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.lock),
                              hintText: 'password',
                              labelText: 'Password',
                            ),
                            style: TextStyle(
                                fontSize: _height * 0.02
                            ),
                            onChanged: _handlePassword,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'パスワードを入力してください';
                              }
                              return null;
                            },
                          )
                      ),
                      Container(
                        width: _width * 0.5,
                        height: _height * 0.06,
                        margin: EdgeInsets.fromLTRB(_width * 0.1, 0, _width * 0.1, _height * 0.05),
                        child: new ElevatedButton(
                          child: Text(
                            'ログイン',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: _height * 0.005,
                              fontSize: _height * 0.02
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black87,
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {

                              // バリデーション成功した場合にログイン処理する
                              _myFirebaseAuth.loginAndMoveUserPage(
                                  this._email,
                                  this._password,
                                  context
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  )
              ),
              Container(
                child: RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'アカウントをお持ちでない場合 ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: _height * 0.017
                              )
                          ),
                          TextSpan(
                              text: '新規登録',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: _height * 0.017
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {

                                  // ユーザー登録画面に遷移
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RegistrationPage()
                                      )
                                  );
                                }
                          )
                        ]
                    )
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  void _handleEmail(String email) {
    this._email = email;
  }

  void _handlePassword(String password) {
    this._password = password;
  }
}
