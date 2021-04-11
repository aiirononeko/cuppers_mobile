import 'package:flutter/material.dart';
import 'dart:developer' as developer;

// カッピング情報詳細画面
class LoginPage extends StatelessWidget {

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
              )
            ],
          ),
        )
    );
  }
}
