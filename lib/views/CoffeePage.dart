import 'package:flutter/material.dart';
import 'dart:developer' as developer;

// カッピング情報詳細画面
class CoffeePage extends StatelessWidget {

  final Map<String, dynamic> coffeeInfo;

  CoffeePage({Key key, @required this.coffeeInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cuppers")),
      body: Column(
        children: <Widget>[
          Text(coffeeInfo['cupped_date'].toDate().toString()),
          Text('${coffeeInfo['coffee_name']} ${coffeeInfo['process']}'),
          Text('Made in ${coffeeInfo['country']}'),
          Text('Score ${coffeeInfo['coffee_score']}'),
          Text('Sweetness ${coffeeInfo['sweetness']}'),
          Text('cleancup ${coffeeInfo['cleancup']}'),
          Text('mousefeel ${coffeeInfo['mousefeel']}'),
          Text('flavor ${coffeeInfo['flavor']}'),
          Text('aftertaste ${coffeeInfo['aftertaste']}'),
          Text('balance ${coffeeInfo['balance']}'),
          Text('overall ${coffeeInfo['overall']}'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_cafe_outlined),
            label: 'Cupping',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border_outlined),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }
}