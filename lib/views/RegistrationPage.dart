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
      appBar: AppBar(
        title: Text(
          'Cuppers',
          style: TextStyle(
              color: Colors.black54
          ),
        ),
        backgroundColor: Colors.white.withOpacity(0.8),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(30, 100, 30, 0),
              child: Text(
                'さあ、',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(30, 0, 30, 50),
              child: Text(
                'カッピングを始めよう！',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 0, 30, 30),
              child: new TextField(
                enabled: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'example@xxx.com',
                  labelText: 'Email',
                ),
                onChanged: _handleEmail,
              )
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 0, 30, 50),
              child: new TextField(
                enabled: true,
                obscureText: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  hintText: 'password',
                  labelText: 'Password',
                ),
                onChanged: _handlePassword,
              )
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: '利用規約',
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).restorablePushNamed('/login'); // TODO 利用規約ページに遷移するように修正
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
                          ..onTap = () {
                            Navigator.of(context).restorablePushNamed('/login'); // TODO プライバシーポリシーページに遷移するように修正
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
              margin: EdgeInsets.fromLTRB(30, 0, 30, 30),
              child: Text(
                '同意して新規登録する',
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 300,
              height: 50,
              margin: EdgeInsets.fromLTRB(30, 0, 30, 30),
              child: new ElevatedButton(
                child: Text(
                  '新規登録',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black87,
                ),
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
