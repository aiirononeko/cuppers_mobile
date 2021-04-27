import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyFirebaseAuth {

  // ユーザー登録処理・ログイン処理をするメソッド
  Future createUserAndLogin(String email, String password, BuildContext context) async {

    try {

      // ユーザー登録処理
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      // ログイン処理
      await loginAndMoveUserPage(email, password, context);

    } on FirebaseAuthException catch(e) {

      if (e.code == 'weak-password') {
        print('This password is valid.');
      } else if (e.code == 'email-already-in-use') {

        showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text('info'),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text('ユーザーはすでに存在します'),
                ),
              ],
            );
          },
        );
      }

    } catch(e) {
      print(e);
    }
  }

  // ログイン処理をしてユーザー画面に遷移するメソッド
  Future loginAndMoveUserPage(String email, String password, BuildContext context) async {

    try {

      // ログイン処理
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password
      );

      // ユーザー画面へ遷移
      Navigator.of(context).pushReplacementNamed('/home');

    } on FirebaseAuthException catch(e) {

      if (e.code == 'user-not-found') {

        showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text('info'),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text('メールアドレスが間違っています'),
                ),
              ],
            );
          },
        );
      } else if (e.code == 'wrong-password') {

        // TODO パスワードを忘れた時の救済措置を用意する
        showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text('info'),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text('パスワードが間違っています'),
                ),
              ],
            );
          },
        );
      }

    } catch(e) {
      print(e);
    }

  }
}
