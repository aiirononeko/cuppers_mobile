import 'package:cuppers_mobile/main.dart';
import 'package:cuppers_mobile/views/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

// カッピング情報詳細画面
class FavoriteListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RaisedButton(
          child: const Text('サインアウト(デバッグ用)'),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage()
                )
            );
          },
        )
    );
  }
}
