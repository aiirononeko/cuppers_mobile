import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

// ログインページ
class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

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
              RaisedButton(
                onPressed: () => {
                  FirebaseAuth.instance
                    .authStateChanges()
                    .listen((User user) {
                      if (user == null) {
                        print('User is sign out!');
                      } else {
                        print('User is signed in!');
                      }
                  })
                },
              )
            ],
          ),
        )
    );
  }
}
