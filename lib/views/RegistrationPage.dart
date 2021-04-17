import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// サインインページ
class RegistrationPage extends StatefulWidget {

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

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
                'さあ、',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                'カッピングを始めよう！',
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
                child: const Text('新規登録'),
                onPressed: () async {
                  try {

                    // ユーザー登録処理
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: this._email,
                        password: this._password
                    );

                    // ログイン処理
                    await FirebaseAuth.instance.signInWithEmailAndPassword(email: this._email, password: this._password);

                    // ユーザー画面へ遷移
                    Navigator.of(context).pushReplacementNamed('/home');

                  } on FirebaseAuthException catch(e) {

                    if (e.code == 'weak-password') {
                      print('This password is valid.');
                    } else if (e.code == 'email-already-in-use') {
                      print('This account is already exists.');
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
                      text: 'すでにアカウントをお持ちの場合 ',
                      style: TextStyle(color: Colors.black)
                    ),
                    TextSpan(
                      text: 'ログイン',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).restorablePushNamed('/login');
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
