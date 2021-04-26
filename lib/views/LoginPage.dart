import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

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
      appBar: AppBar(
        title: Text(
          'Cuppers',
          style: TextStyle(
              color: Colors.black54,
              fontSize: 25
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
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
