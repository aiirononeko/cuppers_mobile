import 'package:cuppers_mobile/main.dart';
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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(30, 130, 30, 50),
                child: Text(
                  'ログインしましょう',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.fromLTRB(30, 0, 30, 30),
                          child: TextFormField(
                            enabled: true,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.email),
                              hintText: 'example@xxx.com',
                              labelText: 'Email',
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
                          margin: EdgeInsets.fromLTRB(30, 0, 30, 50),
                          child: TextFormField(
                            enabled: true,
                            obscureText: true,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.lock),
                              hintText: 'password',
                              labelText: 'Password',
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
                        width: 300,
                        height: 50,
                        margin: EdgeInsets.fromLTRB(30, 0, 30, 30),
                        child: new ElevatedButton(
                          child: Text(
                            'ログイン',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3
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
                              style: TextStyle(color: Colors.black)
                          ),
                          TextSpan(
                              text: '新規登録',
                              style: TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pushReplacementNamed('/registration');
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
