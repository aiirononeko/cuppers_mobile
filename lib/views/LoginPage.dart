import 'package:cuppers_mobile/main.dart';
import 'package:cuppers_mobile/views/RegistrationPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

import './CoffeeIndexPage.dart';

// ログインページ
class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'ログインしましょう',
                style: TextStyle(
                    fontSize: 20
                ),
              ),
              new TextField(
                enabled: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'example@xxx.com',
                  labelText: 'Email',
                ),
                onChanged: _handleEmail,
              ),
              new TextField(
                enabled: true,
                obscureText: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  hintText: 'password',
                  labelText: 'Password',
                ),
                onChanged: _handlePassword,
              ),
              new RaisedButton(
                child: const Text('ログイン'),
                onPressed: () async {
                  try {
                    // ログイン処理
                    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: this._email,
                        password: this._password
                    );

                    // ユーザーページへの遷移
                    Navigator.of(context).pushReplacementNamed('/home');

                  } on FirebaseAuthException catch(e) {
                    if (e.code == 'user-not-found') {
                      print('No user not found for that email.');
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                    }
                  } catch(e) {
                    print(e);
                  }
                },
              ),
              RichText(
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
              )
            ],
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
