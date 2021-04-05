import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

// カッピング情報詳細画面
// class CoffeePage extends StatefulWidget {
//
//   @override
//   _CoffeePageState createState() {
//     return _CoffeePageState();
//   }
// }
//
// class _CoffeePageState extends State<CoffeePage> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Cuppers")),
//       body: Center(
//         child: Text('コーヒー詳細画面です')
//       ),
//     );
//   }
// }

class CoffeePage extends StatelessWidget {

  final String paramText;

  CoffeePage({Key key, @required this.paramText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cuppers")),
      body: Center(
        child: Text(paramText)
      ),
    );
  }
}
