import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

// カッピング情報詳細画面
class CoffeePage extends StatefulWidget {

  @override
  _CoffeePageState createState() {
    return _CoffeePageState();
  }
}

class _CoffeePageState extends State<CoffeePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cuppers")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('coffee').document('bSToUcjAUQU3B698byZ9').snapshots(),
        builder: (context, snapshot) {
          return Text(snapshot.data["name"]);
        },
      ),
    );
  }
}