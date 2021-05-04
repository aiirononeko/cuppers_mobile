import 'package:cuppers_mobile/main.dart';
import 'package:cuppers_mobile/views/LoginPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:cuppers_mobile/services/MyFirebaseAuth.dart';
import 'package:url_launcher/url_launcher.dart';

// サインインページ
class RegistrationPage extends StatefulWidget {

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

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
          margin: EdgeInsets.fromLTRB(_width / 4, _width / 3, _width / 4, _width / 4),
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
                margin: EdgeInsets.fromLTRB(_width / 12, _width / 3.8, _width / 12, 0),
                child: Text(
                  'さあ、',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: _width / 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(_width / 12, 0, _width / 12, _width / 7),
                child: Text(
                  'カッピングを始めよう！',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: _width / 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.fromLTRB(_width / 12, 0, _width / 12, _width / 12),
                        child: TextFormField(
                          enabled: true,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.email),
                            hintText: 'example@xxx.com',
                            labelText: 'Email',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'メールアドレスを入力してください';
                            }
                            if (!RegExp(r'[\w\-\._]+@[\w\-\._]+\.[A-Za-z]+').hasMatch(value)) {
                              return 'メールアドレスが正しくありません';
                            }
                            return null;
                          },
                          onChanged: _handleEmail,
                        )
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(_width / 12, 0, _width / 12, _width / 7),
                        child: TextFormField(
                          enabled: true,
                          obscureText: true,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.lock),
                            hintText: 'password',
                            labelText: 'Password',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'パスワードを入力してください';
                            }
                            if (value.length < 8) {
                              return 'パスワードは8文字以上で設定してください';
                            }
                            return null;
                          },
                          onChanged: _handlePassword,
                        )
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(_width / 12, 0, _width / 12, _width / 50),
                        child: RichText(
                            text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: '利用規約',
                                      style: TextStyle(color: Colors.blue),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          // await launch('https://cuppers-mobile.web.app/');
                                        }
                                  ),
                                  TextSpan(
                                      text: '、 ',
                                      style: TextStyle(color: Colors.black)
                                  ),
                                  TextSpan(
                                      text: 'プライバシーポリシー',
                                      style: TextStyle(color: Colors.blue),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          if (await canLaunch('https://cuppers-mobile.web.app/')) {
                                            await launch('https://cuppers-mobile.web.app/');
                                          }
                                        }
                                  ),
                                  TextSpan(
                                      text: 'に ',
                                      style: TextStyle(color: Colors.black)
                                  )
                                ]
                            )
                        )
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(_width / 12, 0, _width / 12, _width / 12),
                      child: Text(
                        '同意して新規登録する',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 300,
                      height: 50,
                      margin: EdgeInsets.fromLTRB(_width / 12, 0, _width / 12, _width / 12),
                      child: ElevatedButton(
                        child: Text(
                          '新規登録',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                            fontSize: _width / 23
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black87,
                        ),
                        onPressed: () async {

                          if (_formKey.currentState.validate()) {

                            // ユーザー登録・ログイン処理
                            await _myFirebaseAuth.createUserAndLogin(
                                this._email,
                                this._password,
                                context
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'すでにアカウントをお持ちの場合 ',
                            style: TextStyle(color: Colors.black)
                        ),
                        TextSpan(
                            text: 'ログイン',
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => new LoginPage()),
                                        (_) => false);
                              }
                        )
                      ]
                  )
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
