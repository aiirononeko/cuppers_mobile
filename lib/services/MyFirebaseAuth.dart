import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class MyFirebaseAuth {

  // 匿名ユーザーとしてユーザー登録・ログイン処理をするメソッド
  Future createAnonymousUserAndLogin() async {

    try {

      // 匿名ユーザーとして仮登録
      await FirebaseAuth.instance.signInAnonymously();

    } on FirebaseAuthException catch(e) {

      // TODO エラーハンドリング

    } catch(e) {
      print(e);
    }
  }

  // ユーザー登録処理・ログイン処理をするメソッド
  Future createUserAndLogin(String email, String password, BuildContext context) async {

    UserCredential _credential;
    EmailAuthCredential _authCredential;

    try {

      _authCredential = EmailAuthProvider.credential(
        email: email, password: password
      );

      // 匿名ユーザーから永続可能なアカウントへ切り替え
      _credential = await FirebaseAuth.instance.currentUser.linkWithCredential(_authCredential);

      // TODO FirebaseFunctionsで自動実行されるようにする
      // ユーザー情報をFirestoreに登録
      await FirebaseFirestore.instance
        .collection('Users')
        .add({'uid': _credential.user.uid, 'email': email});

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
      Navigator.pushAndRemoveUntil(
          context,
          new MaterialPageRoute(
              builder: (context) => new HomePage()),
              (_) => false);

    } on FirebaseAuthException catch(e) {

      if (e.code == 'user-not-found') {

        showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
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
