import 'package:cuppers_mobile/views/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// アカウント情報表示画面
class AccountInfoPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ElevatedButton(
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
