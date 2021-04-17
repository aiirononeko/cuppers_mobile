import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuppers_mobile/main.dart';
import 'package:cuppers_mobile/views/CoffeePage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

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
                    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: this._email,
                        password: this._password
                    );
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
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (context) => HomePage()
                           )
                         );
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
