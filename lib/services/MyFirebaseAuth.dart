import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class MyFirebaseAuth {

  // ユーザー登録処理をするメソッド
  Future createUserAndLogin(String email, String password) async {

    try {

      // ユーザー登録処理
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
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
        print('No user not found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }

    } catch(e) {
      print(e);
    }

  }
}
