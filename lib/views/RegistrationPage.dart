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
                margin: EdgeInsets.fromLTRB(_width * 0.1, _height * 0.1, _width * 0.1, _height * 0.01),
                child: Text(
                  'さあ、',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: _height * 0.025,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(_width * 0.1, 0, _width * 0.1, _height * 0.08),
                child: Text(
                  'カッピングを始めよう！',
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
                        margin: EdgeInsets.fromLTRB(_width * 0.1, 0, _width * 0.1, _height * 0.05),
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
                        margin: EdgeInsets.fromLTRB(_width * 0.1, 0, _width * 0.1, _height * 0.01),
                        child: RichText(
                            text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: '利用規約',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: _height * 0.017
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          if (await canLaunch('https://cuppers-mobile.web.app/')) {
                                            await launch('https://cuppers-mobile.web.app/');
                                          }
                                        }
                                  ),
                                  TextSpan(
                                      text: '、 ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: _height * 0.017
                                      )
                                  ),
                                  TextSpan(
                                      text: 'プライバシーポリシー',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: _height * 0.017
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          if (await canLaunch('https://cuppers-mobile.web.app/')) {
                                            await launch('https://cuppers-mobile.web.app/');
                                          }
                                        }
                                  ),
                                  TextSpan(
                                      text: 'に',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: _height * 0.017
                                      )
                                  )
                                ]
                            )
                        )
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(_width * 0.1, 0, _width * 0.1, _height * 0.035),
                      child: Text(
                        '同意して新規登録する',
                        style: TextStyle(
                          fontSize: _height * 0.017
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: _width * 0.5,
                      height: _height * 0.06,
                      margin: EdgeInsets.fromLTRB(_width * 0.1, 0, _width * 0.1, _height * 0.05),
                      child: ElevatedButton(
                        child: Text(
                          '新規登録',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: _height * 0.005,
                            fontSize: _height * 0.02
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
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: _height * 0.017
                            ),
                        ),
                        TextSpan(
                            text: 'ログイン',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: _height * 0.017
                            ),
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
