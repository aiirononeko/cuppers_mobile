import 'package:cuppers_mobile/main.dart';
import 'package:cuppers_mobile/views/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

// お気に入りリスト表示画面
class FavoriteListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RaisedButton(
          child: const Text('サインアウト(デバッグ用)'),
          onPressed: () async {

            // サインアウト
            await FirebaseAuth.instance.signOut();

            Navigator.pushAndRemoveUntil(
                context,
                new MaterialPageRoute(
                    builder: (context) => new LoginPage()),
                    (_) => false);
          },
        )
    );
  }
}
