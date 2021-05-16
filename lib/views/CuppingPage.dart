import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuppers_mobile/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:async';

import 'package:flutter/services.dart';

class CuppingPage extends StatefulWidget {

  @override
  _CuppingPageState createState() => _CuppingPageState();
}

// カッピング情報詳細画面
class _CuppingPageState extends State<CuppingPage> {

  // ログイン中のユーザー情報格納用変数
  String _uid = '';

  // カッピングページ表示切り替え機能で使用する変数
  int _selectIndex = 0;

  // カッピングコーヒー切り替え機能で使用する変数
  int _selectCoffeeIndex = 0;

  // タイマー機能で使用する変数
  int _countMinute = 0;
  String _countMinuteStr = '00';
  int _countSecond = 0;
  String _countSecondStr = '00';
  Timer _timer;

  TextEditingController _coffeeNameController;
  TextEditingController _elevationController;
  TextEditingController _roasterController;
  TextEditingController _flavorTextController;
  TextEditingController _commentController;

  TextEditingController _coffeeNameControllerSecond;
  TextEditingController _elevationControllerSecond;
  TextEditingController _roasterControllerSecond;
  TextEditingController _flavorTextControllerSecond;
  TextEditingController _commentControllerSecond;

  TextEditingController _coffeeNameControllerThird;
  TextEditingController _elevationControllerThird;
  TextEditingController _roasterControllerThird;
  TextEditingController _flavorTextControllerThird;
  TextEditingController _commentControllerThird;

  TextEditingController _coffeeNameControllerFourth;
  TextEditingController _elevationControllerFourth;
  TextEditingController _roasterControllerFourth;
  TextEditingController _flavorTextControllerFourth;
  TextEditingController _commentControllerFourth;

  TextEditingController _coffeeNameControllerFifth;
  TextEditingController _elevationControllerFifth;
  TextEditingController _roasterControllerFifth;
  TextEditingController _flavorTextControllerFifth;
  TextEditingController _commentControllerFifth;

  TextEditingController _coffeeNameControllerSixth;
  TextEditingController _elevationControllerSixth;
  TextEditingController _roasterControllerSixth;
  TextEditingController _flavorTextControllerSixth;
  TextEditingController _commentControllerSixth;

  @override
  void initState() {
    super.initState();
    _coffeeNameController = new TextEditingController(text: _coffeeName);
    _elevationController =  new TextEditingController(text: _elevation);
    _roasterController = new TextEditingController(text: _roaster);
    _flavorTextController = new TextEditingController(text: _flavorText);
    _commentController = new TextEditingController(text: _comment);

    _coffeeNameControllerSecond = new TextEditingController(text: _coffeeNameSecond);
    _elevationControllerSecond =  new TextEditingController(text: _elevationSecond);
    _roasterControllerSecond = new TextEditingController(text: _roasterSecond);
    _flavorTextControllerSecond = new TextEditingController(text: _flavorTextSecond);
    _commentControllerSecond = new TextEditingController(text: _commentSecond);

    _coffeeNameControllerThird = new TextEditingController(text: _coffeeNameThird);
    _elevationControllerThird =  new TextEditingController(text: _elevationThird);
    _roasterControllerThird = new TextEditingController(text: _roasterThird);
    _flavorTextControllerThird = new TextEditingController(text: _flavorTextThird);
    _commentControllerThird = new TextEditingController(text: _commentThird);

    _coffeeNameControllerFourth = new TextEditingController(text: _coffeeNameFourth);
    _elevationControllerFourth =  new TextEditingController(text: _elevationFourth);
    _roasterControllerFourth = new TextEditingController(text: _roasterFourth);
    _flavorTextControllerFourth = new TextEditingController(text: _flavorTextFourth);
    _commentControllerFourth = new TextEditingController(text: _commentFourth);

    _coffeeNameControllerFifth = new TextEditingController(text: _coffeeNameFifth);
    _elevationControllerFifth =  new TextEditingController(text: _elevationFifth);
    _roasterControllerFifth = new TextEditingController(text: _roasterFifth);
    _flavorTextControllerFifth = new TextEditingController(text: _flavorTextFifth);
    _commentControllerFifth = new TextEditingController(text: _commentFifth);

    _coffeeNameControllerSixth = new TextEditingController(text: _coffeeNameSixth);
    _elevationControllerSixth =  new TextEditingController(text: _elevationSixth);
    _roasterControllerSixth = new TextEditingController(text: _roasterSixth);
    _flavorTextControllerSixth = new TextEditingController(text: _flavorTextSixth);
    _commentControllerSixth = new TextEditingController(text: _commentSixth);
  }

  // データ書き込み処理時に使用するMap型State
  Map<String, dynamic> _realTimeCuppingData = new Map<String, dynamic>();
  Map<String, dynamic> _realTimeCuppingDataSecond = new Map<String, dynamic>();
  Map<String, dynamic> _realTimeCuppingDataThird = new Map<String, dynamic>();
  Map<String, dynamic> _realTimeCuppingDataFourth = new Map<String, dynamic>();
  Map<String, dynamic> _realTimeCuppingDataFifth = new Map<String, dynamic>();
  Map<String, dynamic> _realTimeCuppingDataSixth = new Map<String, dynamic>();

  String _coffeeName = '';
  String _elevation = '';
  String _roaster = '';
  double _sweetness = 4.0;
  double _acidity = 4.0;
  double _cleanCup = 4.0;
  double _mouseFeel = 4.0;
  double _afterTaste = 4.0;
  double _balance = 4.0;
  double _flavor = 4.0;
  double _overall = 4.0;
  String _flavorText = '';
  String _comment = '';

  void _coffeeNameChanged(String str) => setState(() { _coffeeName = str; });
  void _elevationChanged(String str) => setState(() { _elevation = str; });
  void _roasterChanged(String str) => setState(() { _roaster = str; });
  void _slideSweetness(double e) => setState(() { _sweetness = e; });
  void _slideAcidity(double e) => setState(() { _acidity = e; });
  void _slideCleanCup(double e) => setState(() { _cleanCup = e; });
  void _slideMouseFeel(double e) => setState(() { _mouseFeel = e; });
  void _slideAfterTaste(double e) => setState(() { _afterTaste = e; });
  void _slideBalance(double e) => setState(() { _balance = e; });
  void _slideFlavor(double e) => setState(() { _flavor = e; });
  void _slideOverall(double e) => setState(() { _overall = e; });
  void _flavorTextChanged(String str) => setState(() { _flavorText = str; });
  void _commentChanged(String str) => setState(() { _comment = str; });

  String _coffeeNameSecond = '';
  String _elevationSecond = '';
  String _roasterSecond = '';
  double _sweetnessSecond = 4.0;
  double _aciditySecond = 4.0;
  double _cleanCupSecond = 4.0;
  double _mouseFeelSecond = 4.0;
  double _afterTasteSecond = 4.0;
  double _balanceSecond = 4.0;
  double _flavorSecond = 4.0;
  double _overallSecond = 4.0;
  String _flavorTextSecond = '';
  String _commentSecond = '';

  void _coffeeNameSecondChanged(String str) => setState(() { _coffeeNameSecond = str; });
  void _elevationSecondChanged(String str) => setState(() { _elevationSecond = str; });
  void _roasterSecondChanged(String str) => setState(() { _roasterSecond = str; });
  void _slideSweetnessSecond(double e) => setState(() { _sweetnessSecond = e; });
  void _slideAciditySecond(double e) => setState(() { _aciditySecond = e; });
  void _slideCleanCupSecond(double e) => setState(() { _cleanCupSecond = e; });
  void _slideMouseFeelSecond(double e) => setState(() { _mouseFeelSecond = e; });
  void _slideAfterTasteSecond(double e) => setState(() { _afterTasteSecond = e; });
  void _slideBalanceSecond(double e) => setState(() { _balanceSecond = e; });
  void _slideFlavorSecond(double e) => setState(() { _flavorSecond = e; });
  void _slideOverallSecond(double e) => setState(() { _overallSecond = e; });
  void _flavorTextSecondChanged(String str) => setState(() { _flavorTextSecond = str; });
  void _commentSecondChanged(String str) => setState(() { _commentSecond = str; });

  String _coffeeNameThird = '';
  String _elevationThird = '';
  String _roasterThird = '';
  double _sweetnessThird = 4.0;
  double _acidityThird = 4.0;
  double _cleanCupThird = 4.0;
  double _mouseFeelThird = 4.0;
  double _afterTasteThird = 4.0;
  double _balanceThird = 4.0;
  double _flavorThird = 4.0;
  double _overallThird = 4.0;
  String _flavorTextThird = '';
  String _commentThird = '';

  void _coffeeNameThirdChanged(String str) => setState(() { _coffeeNameThird = str; });
  void _elevationThirdChanged(String str) => setState(() { _elevationThird = str; });
  void _roasterThirdChanged(String str) => setState(() { _roasterThird = str; });
  void _slideSweetnessThird(double e) => setState(() { _sweetnessThird = e; });
  void _slideAcidityThird(double e) => setState(() { _acidityThird = e; });
  void _slideCleanCupThird(double e) => setState(() { _cleanCupThird = e; });
  void _slideMouseFeelThird(double e) => setState(() { _mouseFeelThird = e; });
  void _slideAfterTasteThird(double e) => setState(() { _afterTasteThird = e; });
  void _slideBalanceThird(double e) => setState(() { _balanceThird = e; });
  void _slideFlavorThird(double e) => setState(() { _flavorThird = e; });
  void _slideOverallThird(double e) => setState(() { _overallThird = e; });
  void _flavorTextThirdChanged(String str) => setState(() { _flavorTextThird = str; });
  void _commentThirdChanged(String str) => setState(() { _commentThird = str; });

  String _coffeeNameFourth = '';
  String _elevationFourth = '';
  String _roasterFourth = '';
  double _sweetnessFourth = 4.0;
  double _acidityFourth = 4.0;
  double _cleanCupFourth = 4.0;
  double _mouseFeelFourth = 4.0;
  double _afterTasteFourth = 4.0;
  double _balanceFourth = 4.0;
  double _flavorFourth = 4.0;
  double _overallFourth = 4.0;
  String _flavorTextFourth = '';
  String _commentFourth = '';

  void _coffeeNameFourthChanged(String str) => setState(() { _coffeeNameFourth = str; });
  void _elevationFourthChanged(String str) => setState(() { _elevationFourth = str; });
  void _roasterFourthChanged(String str) => setState(() { _roasterFourth = str; });
  void _slideSweetnessFourth(double e) => setState(() { _sweetnessFourth = e; });
  void _slideAcidityFourth(double e) => setState(() { _acidityFourth = e; });
  void _slideCleanCupFourth(double e) => setState(() { _cleanCupFourth = e; });
  void _slideMouseFeelFourth(double e) => setState(() { _mouseFeelFourth = e; });
  void _slideAfterTasteFourth(double e) => setState(() { _afterTasteFourth = e; });
  void _slideBalanceFourth(double e) => setState(() { _balanceFourth = e; });
  void _slideFlavorFourth(double e) => setState(() { _flavorFourth = e; });
  void _slideOverallFourth(double e) => setState(() { _overallFourth = e; });
  void _flavorTextFourthChanged(String str) => setState(() { _flavorTextFourth = str; });
  void _commentFourthChanged(String str) => setState(() { _commentFourth = str; });

  String _coffeeNameFifth = '';
  String _elevationFifth = '';
  String _roasterFifth = '';
  double _sweetnessFifth = 4.0;
  double _acidityFifth = 4.0;
  double _cleanCupFifth = 4.0;
  double _mouseFeelFifth = 4.0;
  double _afterTasteFifth = 4.0;
  double _balanceFifth = 4.0;
  double _flavorFifth = 4.0;
  double _overallFifth = 4.0;
  String _flavorTextFifth = '';
  String _commentFifth = '';

  void _coffeeNameFifthChanged(String str) => setState(() { _coffeeNameFifth = str; });
  void _elevationFifthChanged(String str) => setState(() { _elevationFifth = str; });
  void _roasterFifthChanged(String str) => setState(() { _roasterFifth = str; });
  void _slideSweetnessFifth(double e) => setState(() { _sweetnessFifth = e; });
  void _slideAcidityFifth(double e) => setState(() { _acidityFifth = e; });
  void _slideCleanCupFifth(double e) => setState(() { _cleanCupFifth = e; });
  void _slideMouseFeelFifth(double e) => setState(() { _mouseFeelFifth = e; });
  void _slideAfterTasteFifth(double e) => setState(() { _afterTasteFifth = e; });
  void _slideBalanceFifth(double e) => setState(() { _balanceFifth = e; });
  void _slideFlavorFifth(double e) => setState(() { _flavorFifth = e; });
  void _slideOverallFifth(double e) => setState(() { _overallFifth = e; });
  void _flavorTextFifthChanged(String str) => setState(() { _flavorTextFifth = str; });
  void _commentFifthChanged(String str) => setState(() { _commentFifth = str; });

  String _coffeeNameSixth = '';
  String _elevationSixth = '';
  String _roasterSixth = '';
  double _sweetnessSixth = 4.0;
  double _aciditySixth = 4.0;
  double _cleanCupSixth = 4.0;
  double _mouseFeelSixth = 4.0;
  double _afterTasteSixth = 4.0;
  double _balanceSixth = 4.0;
  double _flavorSixth = 4.0;
  double _overallSixth = 4.0;
  String _flavorTextSixth = '';
  String _commentSixth = '';

  void _coffeeNameSixthChanged(String str) => setState(() { _coffeeNameSixth = str; });
  void _elevationSixthChanged(String str) => setState(() { _elevationSixth = str; });
  void _roasterSixthChanged(String str) => setState(() { _roasterSixth = str; });
  void _slideSweetnessSixth(double e) => setState(() { _sweetnessSixth = e; });
  void _slideAciditySixth(double e) => setState(() { _aciditySixth = e; });
  void _slideCleanCupSixth(double e) => setState(() { _cleanCupSixth = e; });
  void _slideMouseFeelSixth(double e) => setState(() { _mouseFeelSixth = e; });
  void _slideAfterTasteSixth(double e) => setState(() { _afterTasteSixth = e; });
  void _slideBalanceSixth(double e) => setState(() { _balanceSixth = e; });
  void _slideFlavorSixth(double e) => setState(() { _flavorSixth = e; });
  void _slideOverallSixth(double e) => setState(() { _overallSixth = e; });
  void _flavorTextSixthChanged(String str) => setState(() { _flavorTextSixth = str; });
  void _commentSixthChanged(String str) => setState(() { _commentSixth = str; });

  // ドラムピッカー用のリスト型変数
  String _selectedCountry = 'Country';
  final List<String> _countries = [
    'Brazil',
    'Colombia',
    'Indonesia',
    'Ethiopia',
    'Mexico',
    'Guatemala',
    'Peru',
    'Honduras',
    'Costa Rica',
    'El Salvador',
    'Nicaragua',
    'Ecuador',
    'Thai',
    'Tanzania',
    'Dominicana',
    'Kenya',
    'Burundi',
    'Rwanda',
    'Bolivia',
    'Panama',
    'Other Country'
  ];

  // ドラムピッカー用のリスト型変数
  String _selectedCountrySecond = 'Country';
  final List<String> _countriesSecond = [
    'Brazil',
    'Colombia',
    'Indonesia',
    'Ethiopia',
    'Mexico',
    'Guatemala',
    'Peru',
    'Honduras',
    'Costa Rica',
    'El Salvador',
    'Nicaragua',
    'Ecuador',
    'Thai',
    'Tanzania',
    'Dominicana',
    'Kenya',
    'Burundi',
    'Rwanda',
    'Bolivia',
    'Panama',
    'Other Country'
  ];

  // ドラムピッカー用のリスト型変数
  String _selectedCountryThird = 'Country';
  final List<String> _countriesThird = [
    'Brazil',
    'Colombia',
    'Indonesia',
    'Ethiopia',
    'Mexico',
    'Guatemala',
    'Peru',
    'Honduras',
    'Costa Rica',
    'El Salvador',
    'Nicaragua',
    'Ecuador',
    'Thai',
    'Tanzania',
    'Dominicana',
    'Kenya',
    'Burundi',
    'Rwanda',
    'Bolivia',
    'Panama',
    'Other Country'
  ];

  // ドラムピッカー用のリスト型変数
  String _selectedCountryFourth = 'Country';
  final List<String> _countriesFourth = [
    'Brazil',
    'Colombia',
    'Indonesia',
    'Ethiopia',
    'Mexico',
    'Guatemala',
    'Peru',
    'Honduras',
    'Costa Rica',
    'El Salvador',
    'Nicaragua',
    'Ecuador',
    'Thai',
    'Tanzania',
    'Dominicana',
    'Kenya',
    'Burundi',
    'Rwanda',
    'Bolivia',
    'Panama',
    'Other Country'
  ];

  // ドラムピッカー用のリスト型変数
  String _selectedCountryFifth = 'Country';
  final List<String> _countriesFifth = [
    'Brazil',
    'Colombia',
    'Indonesia',
    'Ethiopia',
    'Mexico',
    'Guatemala',
    'Peru',
    'Honduras',
    'Costa Rica',
    'El Salvador',
    'Nicaragua',
    'Ecuador',
    'Thai',
    'Tanzania',
    'Dominicana',
    'Kenya',
    'Burundi',
    'Rwanda',
    'Bolivia',
    'Panama',
    'Other Country'
  ];

  // ドラムピッカー用のリスト型変数
  String _selectedCountrySixth = 'Country';
  final List<String> _countriesSixth = [
    'Brazil',
    'Colombia',
    'Indonesia',
    'Ethiopia',
    'Mexico',
    'Guatemala',
    'Peru',
    'Honduras',
    'Costa Rica',
    'El Salvador',
    'Nicaragua',
    'Ecuador',
    'Thai',
    'Tanzania',
    'Dominicana',
    'Kenya',
    'Burundi',
    'Rwanda',
    'Bolivia',
    'Panama',
    'Other Country'
  ];

  // ドラムピッカー用のリスト型変数
  String _selectedVariety = 'Variety';
  final List<String> _varieties = [
    'Typica',
    'Bourbon',
    'Yellow Bourbon',
    'Red Bourbon',
    'Cattura',
    'Mundo Novo',
    'Catuai',
    'MaragoGype',
    'San Ramon',
    'Purpurascens',
    'Kent',
    'Pacas',
    'Akkaya',
    'Pacamara',
    'Villa Sarchi',
    'Arusha',
    'Geisha',
    'SL28',
    'SL34',
    'Other Variety'
  ];

  // ドラムピッカー用のリスト型変数
  String _selectedVarietySecond = 'Variety';
  final List<String> _varietiesSecond = [
    'Typica',
    'Bourbon',
    'Yellow Bourbon',
    'Red Bourbon',
    'Cattura',
    'Mundo Novo',
    'Catuai',
    'MaragoGype',
    'San Ramon',
    'Purpurascens',
    'Kent',
    'Pacas',
    'Akkaya',
    'Pacamara',
    'Villa Sarchi',
    'Arusha',
    'Geisha',
    'SL28',
    'SL34',
    'Other Variety'
  ];

  // ドラムピッカー用のリスト型変数
  String _selectedVarietyThird = 'Variety';
  final List<String> _varietiesThird = [
    'Typica',
    'Bourbon',
    'Yellow Bourbon',
    'Red Bourbon',
    'Cattura',
    'Mundo Novo',
    'Catuai',
    'MaragoGype',
    'San Ramon',
    'Purpurascens',
    'Kent',
    'Pacas',
    'Akkaya',
    'Pacamara',
    'Villa Sarchi',
    'Arusha',
    'Geisha',
    'SL28',
    'SL34',
    'Other Variety'
  ];

  // ドラムピッカー用のリスト型変数
  String _selectedVarietyFourth = 'Variety';
  final List<String> _varietiesFourth = [
    'Typica',
    'Bourbon',
    'Yellow Bourbon',
    'Red Bourbon',
    'Cattura',
    'Mundo Novo',
    'Catuai',
    'MaragoGype',
    'San Ramon',
    'Purpurascens',
    'Kent',
    'Pacas',
    'Akkaya',
    'Pacamara',
    'Villa Sarchi',
    'Arusha',
    'Geisha',
    'SL28',
    'SL34',
    'Other Variety'
  ];

  // ドラムピッカー用のリスト型変数
  String _selectedVarietyFifth = 'Variety';
  final List<String> _varietiesFifth = [
    'Typica',
    'Bourbon',
    'Yellow Bourbon',
    'Red Bourbon',
    'Cattura',
    'Mundo Novo',
    'Catuai',
    'MaragoGype',
    'San Ramon',
    'Purpurascens',
    'Kent',
    'Pacas',
    'Akkaya',
    'Pacamara',
    'Villa Sarchi',
    'Arusha',
    'Geisha',
    'SL28',
    'SL34',
    'Other Variety'
  ];

  // ドラムピッカー用のリスト型変数
  String _selectedVarietySixth = 'Variety';
  final List<String> _varietiesSixth = [
    'Typica',
    'Bourbon',
    'Yellow Bourbon',
    'Red Bourbon',
    'Cattura',
    'Mundo Novo',
    'Catuai',
    'MaragoGype',
    'San Ramon',
    'Purpurascens',
    'Kent',
    'Pacas',
    'Akkaya',
    'Pacamara',
    'Villa Sarchi',
    'Arusha',
    'Geisha',
    'SL28',
    'SL34',
    'Other Variety'
  ];

  // ドラムピッカー用のリスト型変数
  String _selectedProcess = 'Process';
  final List<String> _processes = [
    'Washed',
    'Fully Washed',
    'Natural',
    'Pulped Natural',
    'Honey Process',
    'White Honey',
    'Golden Honey',
    'Yellow Honey',
    'Red Honey',
    'Black Honey',
    'Traditional Sumatran Process',
    'Anaerobic',
    'Anaerobic Natural',
    'Anaerobic Washed',
    'Anaerobic Honey',
    'Other Process'
  ];

  // ドラムピッカー用のリスト型変数
  String _selectedProcessSecond = 'Process';
  final List<String> _processesSecond = [
    'Washed',
    'Fully Washed',
    'Natural',
    'Pulped Natural',
    'Honey Process',
    'White Honey',
    'Golden Honey',
    'Yellow Honey',
    'Red Honey',
    'Black Honey',
    'Traditional Sumatran Process',
    'Anaerobic',
    'Anaerobic Natural',
    'Anaerobic Washed',
    'Anaerobic Honey',
    'Other Process'
  ];

  // ドラムピッカー用のリスト型変数
  String _selectedProcessThird = 'Process';
  final List<String> _processesThird = [
    'Washed',
    'Fully Washed',
    'Natural',
    'Pulped Natural',
    'Honey Process',
    'White Honey',
    'Golden Honey',
    'Yellow Honey',
    'Red Honey',
    'Black Honey',
    'Traditional Sumatran Process',
    'Anaerobic',
    'Anaerobic Natural',
    'Anaerobic Washed',
    'Anaerobic Honey',
    'Other Process'
  ];

  // ドラムピッカー用のリスト型変数
  String _selectedProcessFourth = 'Process';
  final List<String> _processesFourth = [
    'Washed',
    'Fully Washed',
    'Natural',
    'Pulped Natural',
    'Honey Process',
    'White Honey',
    'Golden Honey',
    'Yellow Honey',
    'Red Honey',
    'Black Honey',
    'Traditional Sumatran Process',
    'Anaerobic',
    'Anaerobic Natural',
    'Anaerobic Washed',
    'Anaerobic Honey',
    'Other Process'
  ];

  // ドラムピッカー用のリスト型変数
  String _selectedProcessFifth = 'Process';
  final List<String> _processesFifth = [
    'Washed',
    'Fully Washed',
    'Natural',
    'Pulped Natural',
    'Honey Process',
    'White Honey',
    'Golden Honey',
    'Yellow Honey',
    'Red Honey',
    'Black Honey',
    'Traditional Sumatran Process',
    'Anaerobic',
    'Anaerobic Natural',
    'Anaerobic Washed',
    'Anaerobic Honey',
    'Other Process'
  ];

  // ドラムピッカー用のリスト型変数
  String _selectedProcessSixth = 'Process';
  final List<String> _processesSixth = [
    'Washed',
    'Fully Washed',
    'Natural',
    'Pulped Natural',
    'Honey Process',
    'White Honey',
    'Golden Honey',
    'Yellow Honey',
    'Red Honey',
    'Black Honey',
    'Traditional Sumatran Process',
    'Anaerobic',
    'Anaerobic Natural',
    'Anaerobic Washed',
    'Anaerobic Honey',
    'Other Process'
  ];

  @override
  Widget build(BuildContext context) {

    // 画面サイズを取得
    final Size size = MediaQuery.of(context).size;
    final double _width = size.width;
    final double _height = size.height;

    // ログイン中のユーザーIDを取得
    _uid = FirebaseAuth.instance.currentUser.uid;

    // カッピングページ表示項目の制御
    List<Widget> _pageList = [
      _firstCoffeeInfoField(_width, _height), // 0
      _secondCoffeeInfoField(_width, _height), // 1
      _firstCuppingData(_width, _height), // 2
      _secondCuppingData(_width, _height), // 3
      _thirdCuppingData(_width, _height), // 4
      _fourthCuppingData(_width, _height), // 5
      _firstCoffeeInfoFieldSecond(_width, _height), // 6
      _secondCoffeeInfoFieldSecond(_width, _height), // 7
      _firstCuppingDataSecond(_width, _height), // 8
      _secondCuppingDataSecond(_width, _height), // 9
      _thirdCuppingDataSecond(_width, _height), // 10
      _fourthCuppingDataSecond(_width, _height), // 11
      _firstCoffeeInfoFieldThird(_width, _height), // 12
      _secondCoffeeInfoFieldThird(_width, _height), // 13
      _firstCuppingDataThird(_width, _height), // 14
      _secondCuppingDataThird(_width, _height), // 15
      _thirdCuppingDataThird(_width, _height), // 16
      _fourthCuppingDataThird(_width, _height), // 17
      _firstCoffeeInfoFieldFourth(_width, _height), // 18
      _secondCoffeeInfoFieldFourth(_width, _height), // 19
      _firstCuppingDataFourth(_width, _height), // 20
      _secondCuppingDataFourth(_width, _height), // 21
      _thirdCuppingDataFourth(_width, _height), // 22
      _fourthCuppingDataFourth(_width, _height), // 23
      _firstCoffeeInfoFieldFifth(_width, _height), // 24
      _secondCoffeeInfoFieldFifth(_width, _height), // 25
      _firstCuppingDataFifth(_width, _height), // 26
      _secondCuppingDataFifth(_width, _height), // 27
      _thirdCuppingDataFifth(_width, _height), // 28
      _fourthCuppingDataFifth(_width, _height), // 29
      _firstCoffeeInfoFieldSixth(_width, _height), // 30
      _secondCoffeeInfoFieldSixth(_width, _height), // 31
      _firstCuppingDataSixth(_width, _height), // 32
      _secondCuppingDataSixth(_width, _height), // 33
      _thirdCuppingDataSixth(_width, _height), // 34
      _fourthCuppingDataSixth(_width, _height), // 35
    ];

    // カッピングコーヒーの制御
    List<Widget> _coffeeIndex = [
      _buttonOneAble(_width, _height),
      _buttonTwoAble(_width, _height),
      _buttonThreeAble(_width, _height),
      _buttonFourAble(_width, _height),
      _buttonFiveAble(_width, _height),
      _buttonSixAble(_width, _height)
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: HexColor('313131'),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: new IconButton(
          icon: new Icon(Icons.close, color: Colors.white),
          onPressed: () {
            if (this._timer != null) {
              // タイマーをストップする
              this._timer.cancel();
            }
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButton: Column(
        verticalDirection: VerticalDirection.up, // childrenの先頭を下に配置
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            backgroundColor: HexColor('e7e7e7'),
            onPressed: () {

              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    content: Text('カッピングを終了しますか？'),
                    actions: <Widget>[
                      // ボタン領域
                      ElevatedButton(
                        child: Text('Cancel'),
                        style: ElevatedButton.styleFrom(
                          primary: HexColor('313131'),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      ElevatedButton(
                        child: Text('OK'),
                        style: ElevatedButton.styleFrom(
                          primary: HexColor('313131'),
                        ),
                        onPressed: () {

                          // 1杯目のカッピング情報を登録
                          _realTimeCuppingData = _setCuppingData();
                          _writeCuppingData(_realTimeCuppingData, this._uid);

                          // 2杯目のコーヒーがカッピングされていた場合
                          if (this._coffeeNameSecond != '' &&
                              this._selectedCountrySecond != 'Country'
                              // this._varietySecond != '' &&
                              // this._processSecond != '' &&
                              // this._elevationSecond != '0' &&
                              // this._roasterSecond != '')
                          ){
                            // 2杯目のカッピング情報を登録
                            _realTimeCuppingDataSecond = _setCuppingDataSecond();
                            _writeCuppingData(_realTimeCuppingDataSecond, this._uid);

                            // 3杯目のコーヒーがカッピングされていた場合
                            if (this._coffeeNameThird != '' &&
                                this._selectedCountryThird != 'Country'
                                // this._varietyThird != '' &&
                                // this._processThird != '' &&
                                // this._elevationThird != '0' &&
                                // this._roasterThird != ''
                            ){
                              // 3杯目のカッピング情報を登録
                              _realTimeCuppingDataThird = _setCuppingDataThird();
                              _writeCuppingData(_realTimeCuppingDataThird, this._uid);

                              // 4杯目のコーヒーがカッピングされていた場合
                              if (this._coffeeNameFourth != '' &&
                                  this._selectedCountryFourth != 'Country'
                                  // this._varietyFourth != '' &&
                                  // this._processFourth != '' &&
                                  // this._elevationFourth != '0' &&
                                  // this._roasterFourth != ''
                              ){
                                // 4杯目のカッピング情報を登録
                                _realTimeCuppingDataFourth = _setCuppingDataFourth();
                                _writeCuppingData(_realTimeCuppingDataFourth, this._uid);

                                // 5杯目のコーヒーがカッピングされていた場合
                                if (this._coffeeNameFifth != '' &&
                                    this._selectedCountryFifth != 'Country'
                                    // this._varietyFifth != '' &&
                                    // this._processFifth != '' &&
                                    // this._elevationFifth != '0' &&
                                    // this._roasterFifth != ''
                                ){
                                  // 5杯目のカッピング情報を登録
                                  _realTimeCuppingDataFifth = _setCuppingDataFifth();
                                  _writeCuppingData(_realTimeCuppingDataFifth, this._uid);

                                  // 6杯目のコーヒーがカッピングされていた場合
                                  if (this._coffeeNameSixth != '' &&
                                      this._selectedCountrySixth != 'Country'
                                      // this._varietySixth != '' &&
                                      // this._processSixth != '' &&
                                      // this._elevationSixth != '0' &&
                                      // this._roasterSixth != ''
                                  ){
                                    // 6杯目のカッピング情報を登録
                                    _realTimeCuppingDataSixth = _setCuppingDataSixth();
                                    _writeCuppingData(_realTimeCuppingDataSixth, this._uid);
                                  }
                                }
                              }
                            }
                          }

                          // タイマーが起動していた場合
                          if (this._timer != null) {
                            // タイマーをストップする
                            this._timer.cancel();
                          }

                          // ユーザー画面へ遷移
                          Navigator.pushAndRemoveUntil(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new HomePage()),
                                  (_) => false);

                        },
                      ),
                    ],
                  );
                }
              );
            },
            child: Icon(Icons.done, color: HexColor('313131')),
          ),
        ],
      ),
      body: Container(
        color: HexColor('313131'),
        child: Column(
          children: <Widget>[
            Container(
              height: _height * 0.6,
              margin: EdgeInsets.fromLTRB(_width * 0.05, 0, _width * 0.05, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                color: HexColor('e7e7e7'),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: _height * 0.52,
                    child: _pageList[_selectIndex],
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                            icon: const Icon(Icons.navigate_before),
                            onPressed: _selectIndex == 0 || _selectIndex == 6 || _selectIndex == 12 || _selectIndex == 18 || _selectIndex == 24 || _selectIndex == 30 ? null : () {
                              if(_selectIndex > 0) {
                                setState(() {
                                  _selectIndex--;
                                });
                              }
                            }
                        ),
                        IconButton(
                            icon: const Icon(Icons.navigate_next),
                            onPressed: _selectIndex == 5 || _selectIndex == 11 || _selectIndex == 17 || _selectIndex == 23 || _selectIndex == 29 || _selectIndex == 35 ? null: () {
                              if(_selectIndex < 35) {
                                setState(() {
                                  _selectIndex++;
                                });
                              }
                            }
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: _coffeeIndex[_selectCoffeeIndex], // カッピングするコーヒーを切り替え,
            ),
            Container(
              height: _height * 0.18,
              child: Column(
                children: <Widget>[
                  Center(
                   child: Text(
                     '${this._countMinuteStr}:${this._countSecondStr}',
                     style: TextStyle(
                         fontSize: _height * 0.08,
                         color: HexColor('e7e7e7')
                     ),
                   ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.stop, color: HexColor('e7e7e7')),
                          onPressed: () {
                            _resetTimer();
                          }
                      ),
                      IconButton(
                          icon: Icon(Icons.pause, color: HexColor('e7e7e7')),
                          onPressed: () {
                            setState(() {
                              this._timer.cancel();
                            });
                          }
                      ),
                      IconButton(
                          icon: Icon(Icons.play_arrow, color: HexColor('e7e7e7')),
                          onPressed: () {
                            setState(() {

                              // タイマーが起動していなかった場合、タイマーを起動
                              if (this._timer == null) {
                                this._timer = Timer.periodic(Duration(seconds: 1), _onTimer);
                              }
                            });
                          }
                      )
                    ],
                  )
                ],
              )
            ),
          ],
        )
      )
    );
  }

  // コーヒー名などを入力する部分1_1
  Widget _firstCoffeeInfoField(double width, double height) {

    return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
            child: Text(
              'カッピング 1/6',
              style: TextStyle(
                fontSize: height * 0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
            child: Text(
              '各項目を評価してください',
              style: TextStyle(
                  fontSize: height * 0.015
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.065),
            child: TextField(
              controller: _coffeeNameController,
              decoration: InputDecoration(
                labelText: 'Coffee Name',
                hintText: 'Yirgacheffe Konga',
              ),
              style: TextStyle(
                  fontSize: height * 0.02
              ),
              keyboardType: TextInputType.text,
              onChanged: _coffeeNameChanged,
            ),
          ),
          Container(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.01),
                        child: Text(
                          this._selectedCountry,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: height * 0.02
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.055),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _showModalCountriesPicker(context);
                },
              )
          ),
          Container(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.014),
                        child: Text(
                          this._selectedVariety,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: height * 0.02
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _showModalVarietiesPicker(context);
                },
              )
          ),
        ]
    );
  }

  // コーヒー名などを入力する部分1_2
  Widget _secondCoffeeInfoField(double width, double height) {
    return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
            child: Text(
              'カッピング 2/6',
              style: TextStyle(
                fontSize: height * 0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
            child: Text(
              '各項目を評価してください',
              style: TextStyle(
                  fontSize: height * 0.015
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.065),
            child: TextField(
              controller: _elevationController,
              decoration: InputDecoration(
                  labelText: 'Elevation',
                  hintText: '1500'
              ),
              style: TextStyle(
                  fontSize: height * 0.02
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: _elevationChanged,
            ),
          ),
          Container(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.01),
                        child: Text(
                          this._selectedProcess,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: height * 0.02
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _showModalProcessesPicker(context);
                },
              )
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
            child: TextField(
              controller: _roasterController,
              decoration: InputDecoration(
                  labelText: 'Roaster',
                  hintText: 'Reverbed Coffee'
              ),
              style: TextStyle(
                  fontSize: height * 0.02
              ),
              keyboardType: TextInputType.text,
              onChanged: _roasterChanged,
            ),
          ),
        ]
    );
  }

  // カッピング項目入力画面1_1
  Widget _firstCuppingData(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 3/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
            child: Column(
              children: <Widget>[
                Text(
                  'CleanCup',
                  style: TextStyle(
                      fontSize: height * 0.015
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: height * 0.01,
                    thumbColor: HexColor('313131'),
                    overlayColor: HexColor('808080').withAlpha(80),
                    activeTrackColor: HexColor('313131'),
                    inactiveTrackColor: HexColor('cccccc'),
                    inactiveTickMarkColor: HexColor('cccccc'),
                    activeTickMarkColor: HexColor('313131'),
                  ),
                  child: Slider(
                      label: '$_cleanCup',
                      min: 0,
                      max: 8,
                      value: _cleanCup,
                      // activeColor: Colors.orange,
                      // inactiveColor: Colors.blue,
                      divisions: 16,
                      onChanged: _slideCleanCup
                  ),
                )
              ],
            )
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'Sweetness',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_sweetness',
                    min: 0,
                    max: 8,
                    value: _sweetness,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideSweetness
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
          child: Column(
            children: <Widget>[
              Text(
                'Acidity',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_acidity',
                    min: 0,
                    max: 8,
                    value: _acidity,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideAcidity
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // カッピング項目入力画面1_2
  Widget _secondCuppingData(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 4/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'MouseFeel',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_mouseFeel',
                    min: 0,
                    max: 8,
                    value: _mouseFeel,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideMouseFeel
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'AfterTaste',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_afterTaste',
                    min: 0,
                    max: 8,
                    value: _afterTaste,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideAfterTaste
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
          child: Column(
            children: <Widget>[
              Text(
                'Flavor',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_flavor',
                    min: 0,
                    max: 8,
                    value: _flavor,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideFlavor
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // カッピング項目入力画面1_3
  Widget _thirdCuppingData(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 5/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'Balance',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_balance',
                    min: 0,
                    max: 8,
                    value: _balance,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideBalance
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.045),
          child: Column(
            children: <Widget>[
              Text(
                'OverAll',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_overall',
                    min: 0,
                    max: 8,
                    value: _overall,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideOverall
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // カッピング項目入力画面1_4
  Widget _fourthCuppingData(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 6/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.05),
          child: TextField(
            controller: _flavorTextController,
            decoration: InputDecoration(
              labelText: 'Flavor Text',
              hintText: 'Lemon, Peach, Strawberry',
            ),
            style: TextStyle(
                fontSize: height * 0.02
            ),
            keyboardType: TextInputType.text,
            onChanged: _flavorTextChanged,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
          child: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              labelText: 'Comment',
              hintText: 'Silky, Complex, BrightAcidity',
            ),
            style: TextStyle(
                fontSize: height * 0.02
            ),
            keyboardType: TextInputType.text,
            onChanged: _commentChanged,
          ),
        )
      ],
    );
  }

  // コーヒー名などを入力する部分2_1
  Widget _firstCoffeeInfoFieldSecond(double width, double height) {

    return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
            child: Text(
              'カッピング 1/6',
              style: TextStyle(
                fontSize: height * 0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
            child: Text(
              '各項目を評価してください',
              style: TextStyle(
                  fontSize: height * 0.015
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.065),
            child: TextField(
              controller: _coffeeNameControllerSecond,
              decoration: InputDecoration(
                labelText: 'Coffee Name',
                hintText: 'Yirgacheffe Konga',
              ),
              style: TextStyle(
                  fontSize: height * 0.02
              ),
              keyboardType: TextInputType.text,
              onChanged: _coffeeNameSecondChanged,
            ),
          ),
          Container(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.01),
                        child: Text(
                          this._selectedCountrySecond,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: height * 0.02
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.055),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _showModalCountriesPickerSecond(context);
                },
              )
          ),
          Container(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.014),
                        child: Text(
                          this._selectedVarietySecond,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: height * 0.02
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _showModalVarietiesPickerSecond(context);
                },
              )
          ),
        ]
    );
  }

  // コーヒー名などを入力する部分2_2
  Widget _secondCoffeeInfoFieldSecond(double width, double height) {
    return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
            child: Text(
              'カッピング 2/6',
              style: TextStyle(
                fontSize: height * 0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
            child: Text(
              '各項目を評価してください',
              style: TextStyle(
                  fontSize: height * 0.015
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.065),
            child: TextField(
              controller: _elevationControllerSecond,
              decoration: InputDecoration(
                  labelText: 'Elevation',
                  hintText: '1500'
              ),
              style: TextStyle(
                  fontSize: height * 0.02
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: _elevationSecondChanged,
            ),
          ),
          Container(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.01),
                        child: Text(
                          this._selectedProcessSecond,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: height * 0.02
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _showModalProcessesPickerSecond(context);
                },
              )
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
            child: TextField(
              controller: _roasterControllerSecond,
              decoration: InputDecoration(
                  labelText: 'Roaster',
                  hintText: 'Reverbed Coffee'
              ),
              style: TextStyle(
                  fontSize: height * 0.02
              ),
              keyboardType: TextInputType.text,
              onChanged: _roasterSecondChanged,
            ),
          ),
        ]
    );
  }

  // カッピング項目入力画面2_1
  Widget _firstCuppingDataSecond(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 3/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
            child: Column(
              children: <Widget>[
                Text(
                  'CleanCup',
                  style: TextStyle(
                      fontSize: height * 0.015
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: height * 0.01,
                    thumbColor: HexColor('313131'),
                    overlayColor: HexColor('808080').withAlpha(80),
                    activeTrackColor: HexColor('313131'),
                    inactiveTrackColor: HexColor('cccccc'),
                    inactiveTickMarkColor: HexColor('cccccc'),
                    activeTickMarkColor: HexColor('313131'),
                  ),
                  child: Slider(
                      label: '$_cleanCupSecond',
                      min: 0,
                      max: 8,
                      value: _cleanCupSecond,
                      // activeColor: Colors.orange,
                      // inactiveColor: Colors.blue,
                      divisions: 16,
                      onChanged: _slideCleanCupSecond
                  ),
                )
              ],
            )
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'Sweetness',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_sweetnessSecond',
                    min: 0,
                    max: 8,
                    value: _sweetnessSecond,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideSweetnessSecond
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
          child: Column(
            children: <Widget>[
              Text(
                'Acidity',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_aciditySecond',
                    min: 0,
                    max: 8,
                    value: _aciditySecond,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideAciditySecond
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // カッピング項目入力画面2_2
  Widget _secondCuppingDataSecond(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 4/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'MouseFeel',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_mouseFeelSecond',
                    min: 0,
                    max: 8,
                    value: _mouseFeelSecond,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideMouseFeelSecond
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'AfterTaste',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_afterTasteSecond',
                    min: 0,
                    max: 8,
                    value: _afterTasteSecond,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideAfterTasteSecond
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
          child: Column(
            children: <Widget>[
              Text(
                'Flavor',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_flavorSecond',
                    min: 0,
                    max: 8,
                    value: _flavorSecond,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideFlavorSecond
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // カッピング項目入力画面2_3
  Widget _thirdCuppingDataSecond(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 5/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'Balance',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_balanceSecond',
                    min: 0,
                    max: 8,
                    value: _balanceSecond,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideBalanceSecond
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'OverAll',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_overallSecond',
                    min: 0,
                    max: 8,
                    value: _overallSecond,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideOverallSecond
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // カッピング項目入力画面2_4
  Widget _fourthCuppingDataSecond(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 6/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.05),
          child: TextField(
            controller: _flavorTextControllerSecond,
            decoration: InputDecoration(
              labelText: 'Flavor Text',
              hintText: 'Lemon, Peach, Strawberry',
            ),
            style: TextStyle(
                fontSize: height * 0.02
            ),
            keyboardType: TextInputType.text,
            onChanged: _flavorTextSecondChanged,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
          child: TextField(
            controller: _commentControllerSecond,
            decoration: InputDecoration(
              labelText: 'Comment',
              hintText: 'Silky, Complex, BrightAcidity',
            ),
            style: TextStyle(
                fontSize: height * 0.02
            ),
            keyboardType: TextInputType.text,
            onChanged: _commentSecondChanged,
          ),
        )
      ],
    );
  }

  // コーヒー名などを入力する部分3_1
  Widget _firstCoffeeInfoFieldThird(double width, double height) {

    return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
            child: Text(
              'カッピング 1/6',
              style: TextStyle(
                fontSize: height * 0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
            child: Text(
              '各項目を評価してください',
              style: TextStyle(
                  fontSize: height * 0.015
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.065),
            child: TextField(
              controller: _coffeeNameControllerThird,
              decoration: InputDecoration(
                labelText: 'Coffee Name',
                hintText: 'Yirgacheffe Konga',
              ),
              style: TextStyle(
                  fontSize: height * 0.02
              ),
              keyboardType: TextInputType.text,
              onChanged: _coffeeNameThirdChanged,
            ),
          ),
          Container(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.01),
                        child: Text(
                          this._selectedCountryThird,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: height * 0.02
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.055),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _showModalCountriesPickerThird(context);
                },
              )
          ),
          Container(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.014),
                        child: Text(
                          this._selectedVarietyThird,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: height * 0.02
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _showModalVarietiesPickerThird(context);
                },
              )
          ),
        ]
    );
  }

  // コーヒー名などを入力する部分3_2
  Widget _secondCoffeeInfoFieldThird(double width, double height) {
    return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
            child: Text(
              'カッピング 2/6',
              style: TextStyle(
                fontSize: height * 0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
            child: Text(
              '各項目を評価してください',
              style: TextStyle(
                  fontSize: height * 0.015
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.065),
            child: TextField(
              controller: _elevationControllerThird,
              decoration: InputDecoration(
                  labelText: 'Elevation',
                  hintText: '1500'
              ),
              style: TextStyle(
                  fontSize: height * 0.02
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: _elevationThirdChanged,
            ),
          ),
          Container(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.01),
                        child: Text(
                          this._selectedProcessThird,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: height * 0.02
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _showModalProcessesPickerThird(context);
                },
              )
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
            child: TextField(
              controller: _roasterControllerThird,
              decoration: InputDecoration(
                  labelText: 'Roaster',
                  hintText: 'Reverbed Coffee'
              ),
              style: TextStyle(
                  fontSize: height * 0.02
              ),
              keyboardType: TextInputType.text,
              onChanged: _roasterThirdChanged,
            ),
          ),
        ]
    );
  }

  // カッピング項目入力画面3_1
  Widget _firstCuppingDataThird(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 3/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
            child: Column(
              children: <Widget>[
                Text(
                  'CleanCup',
                  style: TextStyle(
                      fontSize: height * 0.015
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: height * 0.01,
                    thumbColor: HexColor('313131'),
                    overlayColor: HexColor('808080').withAlpha(80),
                    activeTrackColor: HexColor('313131'),
                    inactiveTrackColor: HexColor('cccccc'),
                    inactiveTickMarkColor: HexColor('cccccc'),
                    activeTickMarkColor: HexColor('313131'),
                  ),
                  child: Slider(
                      label: '$_cleanCupThird',
                      min: 0,
                      max: 8,
                      value: _cleanCupThird,
                      // activeColor: Colors.orange,
                      // inactiveColor: Colors.blue,
                      divisions: 16,
                      onChanged: _slideCleanCupThird
                  ),
                )
              ],
            )
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'Sweetness',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_sweetnessThird',
                    min: 0,
                    max: 8,
                    value: _sweetnessThird,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideSweetnessThird
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
          child: Column(
            children: <Widget>[
              Text(
                'Acidity',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_acidityThird',
                    min: 0,
                    max: 8,
                    value: _acidityThird,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideAcidityThird
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // カッピング項目入力画面3_2
  Widget _secondCuppingDataThird(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 4/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'MouseFeel',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_mouseFeelThird',
                    min: 0,
                    max: 8,
                    value: _mouseFeelThird,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideMouseFeelThird
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'AfterTaste',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_afterTasteThird',
                    min: 0,
                    max: 8,
                    value: _afterTasteThird,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideAfterTasteThird
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
          child: Column(
            children: <Widget>[
              Text(
                'Flavor',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_flavorThird',
                    min: 0,
                    max: 8,
                    value: _flavorThird,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideFlavorThird
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // カッピング項目入力画面3_3
  Widget _thirdCuppingDataThird(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 5/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'Balance',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_balanceThird',
                    min: 0,
                    max: 8,
                    value: _balanceThird,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideBalanceThird
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'OverAll',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_overallThird',
                    min: 0,
                    max: 8,
                    value: _overallThird,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideOverallThird
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // カッピング項目入力画面3_4
  Widget _fourthCuppingDataThird(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 6/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.05),
          child: TextField(
            controller: _flavorTextControllerThird,
            decoration: InputDecoration(
              labelText: 'Flavor Text',
              hintText: 'Lemon, Peach, Strawberry',
            ),
            style: TextStyle(
                fontSize: height * 0.02
            ),
            keyboardType: TextInputType.text,
            onChanged: _flavorTextThirdChanged,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
          child: TextField(
            controller: _commentControllerThird,
            decoration: InputDecoration(
              labelText: 'Comment',
              hintText: 'Silky, Complex, BrightAcidity',
            ),
            style: TextStyle(
                fontSize: height * 0.02
            ),
            keyboardType: TextInputType.text,
            onChanged: _commentThirdChanged,
          ),
        )
      ],
    );
  }

  // コーヒー名などを入力する部分4_1
  Widget _firstCoffeeInfoFieldFourth(double width, double height) {

    return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
            child: Text(
              'カッピング 1/6',
              style: TextStyle(
                fontSize: height * 0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
            child: Text(
              '各項目を評価してください',
              style: TextStyle(
                  fontSize: height * 0.015
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.065),
            child: TextField(
              controller: _coffeeNameControllerFourth,
              decoration: InputDecoration(
                labelText: 'Coffee Name',
                hintText: 'Yirgacheffe Konga',
              ),
              style: TextStyle(
                  fontSize: height * 0.02
              ),
              keyboardType: TextInputType.text,
              onChanged: _coffeeNameFourthChanged,
            ),
          ),
          Container(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.01),
                        child: Text(
                          this._selectedCountryFourth,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: height * 0.02
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.055),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _showModalCountriesPickerFourth(context);
                },
              )
          ),
          Container(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.014),
                        child: Text(
                          this._selectedVarietyFourth,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: height * 0.02
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _showModalVarietiesPickerFourth(context);
                },
              )
          ),
        ]
    );
  }

  // コーヒー名などを入力する部分4_2
  Widget _secondCoffeeInfoFieldFourth(double width, double height) {
    return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
            child: Text(
              'カッピング 2/6',
              style: TextStyle(
                fontSize: height * 0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
            child: Text(
              '各項目を評価してください',
              style: TextStyle(
                  fontSize: height * 0.015
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.065),
            child: TextField(
              controller: _elevationControllerFourth,
              decoration: InputDecoration(
                  labelText: 'Elevation',
                  hintText: '1500'
              ),
              style: TextStyle(
                  fontSize: height * 0.02
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: _elevationFourthChanged,
            ),
          ),
          Container(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.01),
                        child: Text(
                          this._selectedProcessFourth,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: height * 0.02
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _showModalProcessesPickerFourth(context);
                },
              )
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
            child: TextField(
              controller: _roasterControllerFourth,
              decoration: InputDecoration(
                  labelText: 'Roaster',
                  hintText: 'Reverbed Coffee'
              ),
              style: TextStyle(
                  fontSize: height * 0.02
              ),
              keyboardType: TextInputType.text,
              onChanged: _roasterFourthChanged,
            ),
          ),
        ]
    );
  }

  // カッピング項目入力画面4_1
  Widget _firstCuppingDataFourth(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 3/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
            child: Column(
              children: <Widget>[
                Text(
                  'CleanCup',
                  style: TextStyle(
                      fontSize: height * 0.015
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: height * 0.01,
                    thumbColor: HexColor('313131'),
                    overlayColor: HexColor('808080').withAlpha(80),
                    activeTrackColor: HexColor('313131'),
                    inactiveTrackColor: HexColor('cccccc'),
                    inactiveTickMarkColor: HexColor('cccccc'),
                    activeTickMarkColor: HexColor('313131'),
                  ),
                  child: Slider(
                      label: '$_cleanCupFourth',
                      min: 0,
                      max: 8,
                      value: _cleanCupFourth,
                      // activeColor: Colors.orange,
                      // inactiveColor: Colors.blue,
                      divisions: 16,
                      onChanged: _slideCleanCupFourth
                  ),
                )
              ],
            )
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'Sweetness',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_sweetnessFourth',
                    min: 0,
                    max: 8,
                    value: _sweetnessFourth,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideSweetnessFourth
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
          child: Column(
            children: <Widget>[
              Text(
                'Acidity',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_acidityFourth',
                    min: 0,
                    max: 8,
                    value: _acidityFourth,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideAcidityFourth
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // カッピング項目入力画面4_2
  Widget _secondCuppingDataFourth(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 4/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'MouseFeel',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_mouseFeelFourth',
                    min: 0,
                    max: 8,
                    value: _mouseFeelFourth,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideMouseFeelFourth
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'AfterTaste',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_afterTasteFourth',
                    min: 0,
                    max: 8,
                    value: _afterTasteFourth,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideAfterTasteFourth
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
          child: Column(
            children: <Widget>[
              Text(
                'Flavor',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_flavorFourth',
                    min: 0,
                    max: 8,
                    value: _flavorFourth,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideFlavorFourth
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // カッピング項目入力画面4_3
  Widget _thirdCuppingDataFourth(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 5/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'Balance',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_balanceFourth',
                    min: 0,
                    max: 8,
                    value: _balanceFourth,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideBalanceFourth
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'OverAll',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_overallFourth',
                    min: 0,
                    max: 8,
                    value: _overallFourth,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideOverallFourth
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // カッピング項目入力画面4_4
  Widget _fourthCuppingDataFourth(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 6/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.05),
          child: TextField(
            controller: _flavorTextControllerFourth,
            decoration: InputDecoration(
              labelText: 'Flavor Text',
              hintText: 'Lemon, Peach, Strawberry',
            ),
            style: TextStyle(
                fontSize: height * 0.02
            ),
            keyboardType: TextInputType.text,
            onChanged: _flavorTextFourthChanged,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
          child: TextField(
            controller: _commentControllerFourth,
            decoration: InputDecoration(
              labelText: 'Comment',
              hintText: 'Silky, Complex, BrightAcidity',
            ),
            style: TextStyle(
                fontSize: height * 0.02
            ),
            keyboardType: TextInputType.text,
            onChanged: _commentFourthChanged,
          ),
        )
      ],
    );
  }

  // コーヒー名などを入力する部分5_1
  Widget _firstCoffeeInfoFieldFifth(double width, double height) {

    return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
            child: Text(
              'カッピング 1/6',
              style: TextStyle(
                fontSize: height * 0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
            child: Text(
              '各項目を評価してください',
              style: TextStyle(
                  fontSize: height * 0.015
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.065),
            child: TextField(
              controller: _coffeeNameControllerFifth,
              decoration: InputDecoration(
                labelText: 'Coffee Name',
                hintText: 'Yirgacheffe Konga',
              ),
              style: TextStyle(
                  fontSize: height * 0.02
              ),
              keyboardType: TextInputType.text,
              onChanged: _coffeeNameFifthChanged,
            ),
          ),
          Container(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.01),
                        child: Text(
                          this._selectedCountryFifth,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: height * 0.02
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.055),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _showModalCountriesPickerFifth(context);
                },
              )
          ),
          Container(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.014),
                        child: Text(
                          this._selectedVarietyFifth,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: height * 0.02
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _showModalVarietiesPickerFifth(context);
                },
              )
          ),
        ]
    );
  }

  // コーヒー名などを入力する部分5_2
  Widget _secondCoffeeInfoFieldFifth(double width, double height) {
    return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
            child: Text(
              'カッピング 2/6',
              style: TextStyle(
                fontSize: height * 0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
            child: Text(
              '各項目を評価してください',
              style: TextStyle(
                  fontSize: height * 0.015
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.065),
            child: TextField(
              controller: _elevationControllerFifth,
              decoration: InputDecoration(
                  labelText: 'Elevation',
                  hintText: '1500'
              ),
              style: TextStyle(
                  fontSize: height * 0.02
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: _elevationFifthChanged,
            ),
          ),
          Container(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.01),
                        child: Text(
                          this._selectedProcessFifth,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: height * 0.02
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _showModalProcessesPickerFifth(context);
                },
              )
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
            child: TextField(
              controller: _roasterControllerFifth,
              decoration: InputDecoration(
                  labelText: 'Roaster',
                  hintText: 'Reverbed Coffee'
              ),
              style: TextStyle(
                  fontSize: height * 0.02
              ),
              keyboardType: TextInputType.text,
              onChanged: _roasterFifthChanged,
            ),
          ),
        ]
    );
  }

  // カッピング項目入力画面5_1
  Widget _firstCuppingDataFifth(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 3/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
            child: Column(
              children: <Widget>[
                Text(
                  'CleanCup',
                  style: TextStyle(
                      fontSize: height * 0.015
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: height * 0.01,
                    thumbColor: HexColor('313131'),
                    overlayColor: HexColor('808080').withAlpha(80),
                    activeTrackColor: HexColor('313131'),
                    inactiveTrackColor: HexColor('cccccc'),
                    inactiveTickMarkColor: HexColor('cccccc'),
                    activeTickMarkColor: HexColor('313131'),
                  ),
                  child: Slider(
                      label: '$_cleanCupFifth',
                      min: 0,
                      max: 8,
                      value: _cleanCupFifth,
                      // activeColor: Colors.orange,
                      // inactiveColor: Colors.blue,
                      divisions: 16,
                      onChanged: _slideCleanCupFifth
                  ),
                )
              ],
            )
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'Sweetness',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_sweetnessFifth',
                    min: 0,
                    max: 8,
                    value: _sweetnessFifth,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideSweetnessFifth
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
          child: Column(
            children: <Widget>[
              Text(
                'Acidity',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_acidityFifth',
                    min: 0,
                    max: 8,
                    value: _acidityFifth,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideAcidityFifth
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // カッピング項目入力画面5_2
  Widget _secondCuppingDataFifth(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 4/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'MouseFeel',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_mouseFeelFifth',
                    min: 0,
                    max: 8,
                    value: _mouseFeelFifth,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideMouseFeelFifth
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'AfterTaste',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_afterTasteFifth',
                    min: 0,
                    max: 8,
                    value: _afterTasteFifth,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideAfterTasteFifth
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
          child: Column(
            children: <Widget>[
              Text(
                'Flavor',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_flavorFifth',
                    min: 0,
                    max: 8,
                    value: _flavorFifth,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideFlavorFifth
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // カッピング項目入力画面5_3
  Widget _thirdCuppingDataFifth(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 5/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'Balance',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_balanceFifth',
                    min: 0,
                    max: 8,
                    value: _balanceFifth,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideBalanceFifth
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'OverAll',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_overallFifth',
                    min: 0,
                    max: 8,
                    value: _overallFifth,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideOverallFifth
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // カッピング項目入力画面5_4
  Widget _fourthCuppingDataFifth(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 6/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.05),
          child: TextField(
            controller: _flavorTextControllerFifth,
            decoration: InputDecoration(
              labelText: 'Flavor Text',
              hintText: 'Lemon, Peach, Strawberry',
            ),
            style: TextStyle(
                fontSize: height * 0.02
            ),
            keyboardType: TextInputType.text,
            onChanged: _flavorTextFifthChanged,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
          child: TextField(
            controller: _commentControllerFifth,
            decoration: InputDecoration(
              labelText: 'Comment',
              hintText: 'Silky, Complex, BrightAcidity',
            ),
            style: TextStyle(
                fontSize: height * 0.02
            ),
            keyboardType: TextInputType.text,
            onChanged: _commentFifthChanged,
          ),
        )
      ],
    );
  }

  // コーヒー名などを入力する部分6_1
  Widget _firstCoffeeInfoFieldSixth(double width, double height) {

    return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
            child: Text(
              'カッピング 1/6',
              style: TextStyle(
                fontSize: height * 0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
            child: Text(
              '各項目を評価してください',
              style: TextStyle(
                  fontSize: height * 0.015
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.065),
            child: TextField(
              controller: _coffeeNameControllerSixth,
              decoration: InputDecoration(
                labelText: 'Coffee Name',
                hintText: 'Yirgacheffe Konga',
              ),
              style: TextStyle(
                  fontSize: height * 0.02
              ),
              keyboardType: TextInputType.text,
              onChanged: _coffeeNameSixthChanged,
            ),
          ),
          Container(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.01),
                        child: Text(
                          this._selectedCountrySixth,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: height * 0.02
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.055),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _showModalCountriesPickerSixth(context);
                },
              )
          ),
          Container(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.014),
                        child: Text(
                          this._selectedVarietySixth,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: height * 0.02
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _showModalVarietiesPickerSixth(context);
                },
              )
          ),
        ]
    );
  }

  // コーヒー名などを入力する部分6_2
  Widget _secondCoffeeInfoFieldSixth(double width, double height) {
    return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
            child: Text(
              'カッピング 2/6',
              style: TextStyle(
                fontSize: height * 0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
            child: Text(
              '各項目を評価してください',
              style: TextStyle(
                  fontSize: height * 0.015
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.065),
            child: TextField(
              controller: _elevationControllerSixth,
              decoration: InputDecoration(
                  labelText: 'Elevation',
                  hintText: '1500'
              ),
              style: TextStyle(
                  fontSize: height * 0.02
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: _elevationSixthChanged,
            ),
          ),
          Container(
              child: InkWell(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.01),
                        child: Text(
                          this._selectedProcessSixth,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: height * 0.02
                          ),
                        )
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _showModalProcessesPickerSixth(context);
                },
              )
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
            child: TextField(
              controller: _roasterControllerSixth,
              decoration: InputDecoration(
                  labelText: 'Roaster',
                  hintText: 'Reverbed Coffee'
              ),
              style: TextStyle(
                  fontSize: height * 0.02
              ),
              keyboardType: TextInputType.text,
              onChanged: _roasterSixthChanged,
            ),
          ),
        ]
    );
  }

  // カッピング項目入力画面6_1
  Widget _firstCuppingDataSixth(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 3/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
            child: Column(
              children: <Widget>[
                Text(
                  'CleanCup',
                  style: TextStyle(
                      fontSize: height * 0.015
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: height * 0.01,
                    thumbColor: HexColor('313131'),
                    overlayColor: HexColor('808080').withAlpha(80),
                    activeTrackColor: HexColor('313131'),
                    inactiveTrackColor: HexColor('cccccc'),
                    inactiveTickMarkColor: HexColor('cccccc'),
                    activeTickMarkColor: HexColor('313131'),
                  ),
                  child: Slider(
                      label: '$_cleanCupSixth',
                      min: 0,
                      max: 8,
                      value: _cleanCupSixth,
                      // activeColor: Colors.orange,
                      // inactiveColor: Colors.blue,
                      divisions: 16,
                      onChanged: _slideCleanCupSixth
                  ),
                )
              ],
            )
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'Sweetness',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_sweetnessSixth',
                    min: 0,
                    max: 8,
                    value: _sweetnessSixth,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideSweetnessSixth
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
          child: Column(
            children: <Widget>[
              Text(
                'Acidity',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_aciditySixth',
                    min: 0,
                    max: 8,
                    value: _aciditySixth,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideAciditySixth
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // カッピング項目入力画面6_2
  Widget _secondCuppingDataSixth(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 4/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'MouseFeel',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_mouseFeelSixth',
                    min: 0,
                    max: 8,
                    value: _mouseFeelSixth,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideMouseFeelSixth
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'AfterTaste',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_afterTasteSixth',
                    min: 0,
                    max: 8,
                    value: _afterTasteSixth,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideAfterTasteSixth
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
          child: Column(
            children: <Widget>[
              Text(
                'Flavor',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_flavorSixth',
                    min: 0,
                    max: 8,
                    value: _flavorSixth,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideFlavorSixth
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // カッピング項目入力画面6_3
  Widget _thirdCuppingDataSixth(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 5/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'Balance',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_balanceSixth',
                    min: 0,
                    max: 8,
                    value: _balanceSixth,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideBalanceSixth
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.03),
          child: Column(
            children: <Widget>[
              Text(
                'OverAll',
                style: TextStyle(
                    fontSize: height * 0.015
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: height * 0.01,
                  thumbColor: HexColor('313131'),
                  overlayColor: HexColor('808080').withAlpha(80),
                  activeTrackColor: HexColor('313131'),
                  inactiveTrackColor: HexColor('cccccc'),
                  inactiveTickMarkColor: HexColor('cccccc'),
                  activeTickMarkColor: HexColor('313131'),
                ),
                child: Slider(
                    label: '$_overallSixth',
                    min: 0,
                    max: 8,
                    value: _overallSixth,
                    // activeColor: Colors.orange,
                    // inactiveColor: Colors.blue,
                    divisions: 16,
                    onChanged: _slideOverallSixth
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // カッピング項目入力画面6_4
  Widget _fourthCuppingDataSixth(double width, double height) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.01),
          child: Text(
            'カッピング 6/6',
            style: TextStyle(
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, height * 0.05),
          child: Text(
            '各項目を評価してください',
            style: TextStyle(
                fontSize: height * 0.015
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, height * 0.05),
          child: TextField(
            controller: _flavorTextControllerSixth,
            decoration: InputDecoration(
              labelText: 'Flavor Text',
              hintText: 'Lemon, Peach, Strawberry',
            ),
            style: TextStyle(
                fontSize: height * 0.02
            ),
            keyboardType: TextInputType.text,
            onChanged: _flavorTextSixthChanged,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.15, 0, width * 0.15, 0),
          child: TextField(
            controller: _commentControllerSixth,
            decoration: InputDecoration(
              labelText: 'Comment',
              hintText: 'Silky, Complex, BrightAcidity',
            ),
            style: TextStyle(
                fontSize: height * 0.02
            ),
            keyboardType: TextInputType.text,
            onChanged: _commentSixthChanged,
          ),
        )
      ],
    );
  }

  Widget _buttonOneAble(double width, double height) {
    return Container(
        margin: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, height * 0.02),
        child: Row(
          children: <Widget>[
            Container(
                width: width * 0.15,
                height: height * 0.065,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  color: HexColor('e7e7e7'),
                ),
                child: Container(
                  child: IconButton(
                    icon: Container(
                      child: Image.asset('images/sozai_cman_jp_20210508161854.png'),
                    ),
                    onPressed: () {},
                  ),
                )
            ),
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508162004.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 6;
                    this._selectCoffeeIndex = 1;
                  });
                },
              ),
            ),
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508162007.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 12;
                    this._selectCoffeeIndex = 2;
                  });
                },
              ),
            ),
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508162011.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 18;
                    this._selectCoffeeIndex = 3;
                  });
                },
              ),
            ),
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508162013.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 24;
                    this._selectCoffeeIndex = 4;
                  });
                },
              ),
            ),
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508162016.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 30;
                    this._selectCoffeeIndex = 5;
                  });
                },
              ),
            ),
          ],
        )
    );
  }


  Widget _buttonTwoAble(double width, double height) {
    return Container(
      margin: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, height * 0.02),
      child: Row(
        children: <Widget>[
          Container(
            width: width * 0.15,
            height: height * 0.065,
            child: IconButton(
              icon: Container(
                child: Image.asset('images/sozai_cman_jp_20210508161921.png'),
              ),
              onPressed: () {
                setState(() {
                  this._selectIndex = 0;
                  this._selectCoffeeIndex = 0;
                });
              },
            ),
          ),
          Container(
              width: width * 0.15,
              height: height * 0.065,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                color: HexColor('e7e7e7'),
              ),
              child: Container(
                child: IconButton(
                  icon: Container(
                    child: Image.asset('images/sozai_cman_jp_20210508161942.png'),
                  ),
                  onPressed: () {},
                ),
              )
          ),
          Container(
            width: width * 0.15,
            height: height * 0.065,
            child: IconButton(
              icon: Container(
                child: Image.asset('images/sozai_cman_jp_20210508162007.png'),
              ),
              onPressed: () {
                setState(() {
                  this._selectIndex = 12;
                  this._selectCoffeeIndex = 2;
                });
              },
            ),
          ),
          Container(
            width: width * 0.15,
            height: height * 0.065,
            child: IconButton(
              icon: Container(
                child: Image.asset('images/sozai_cman_jp_20210508162011.png'),
              ),
              onPressed: () {
                setState(() {
                  this._selectIndex = 18;
                  this._selectCoffeeIndex = 3;
                });
              },
            ),
          ),
          Container(
            width: width * 0.15,
            height: height * 0.065,
            child: IconButton(
              icon: Container(
                child: Image.asset('images/sozai_cman_jp_20210508162013.png'),
              ),
              onPressed: () {
                setState(() {
                  this._selectIndex = 24;
                  this._selectCoffeeIndex = 4;
                });
              },
            ),
          ),
          Container(
            width: width * 0.15,
            height: height * 0.065,
            child: IconButton(
              icon: Container(
                child: Image.asset('images/sozai_cman_jp_20210508162016.png'),
              ),
              onPressed: () {
                setState(() {
                  this._selectIndex = 30;
                  this._selectCoffeeIndex = 5;
                });
              },
            ),
          ),
        ],
      )
    );
  }

  Widget _buttonThreeAble(double width, double height) {
    return Container(
        margin: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, height * 0.02),
        child: Row(
          children: <Widget>[
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508161921.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 0;
                    this._selectCoffeeIndex = 0;
                  });
                },
              ),
            ),
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508162004.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 6;
                    this._selectCoffeeIndex = 1;
                  });
                },
              ),
            ),
            Container(
                width: width * 0.15,
                height: height * 0.065,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  color: HexColor('e7e7e7'),
                ),
                child: Container(
                  child: IconButton(
                    icon: Container(
                      child: Image.asset('images/sozai_cman_jp_20210508161946.png'),
                    ),
                    onPressed: () {},
                  ),
                )
            ),
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508162011.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 18;
                    this._selectCoffeeIndex = 3;
                  });
                },
              ),
            ),
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508162013.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 24;
                    this._selectCoffeeIndex = 4;
                  });
                },
              ),
            ),
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508162016.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 30;
                    this._selectCoffeeIndex = 5;
                  });
                },
              ),
            ),
          ],
        )
    );
  }

  Widget _buttonFourAble(double width, double height) {
    return Container(
        margin: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, height * 0.02),
        child: Row(
          children: <Widget>[
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508161921.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 0;
                    this._selectCoffeeIndex = 0;
                  });
                },
              ),
            ),
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508162004.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 6;
                    this._selectCoffeeIndex = 1;
                  });
                },
              ),
            ),
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508162007.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 12;
                    this._selectCoffeeIndex = 2;
                  });
                },
              ),
            ),
            Container(
                width: width * 0.15,
                height: height * 0.065,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  color: HexColor('e7e7e7'),
                ),
                child: Container(
                  child: IconButton(
                    icon: Container(
                      child: Image.asset('images/sozai_cman_jp_20210508161949.png'),
                    ),
                    onPressed: () {},
                  ),
                )
            ),
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508162013.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 24;
                    this._selectCoffeeIndex = 4;
                  });
                },
              ),
            ),
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508162016.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 30;
                    this._selectCoffeeIndex = 5;
                  });
                },
              ),
            ),
          ],
        )
    );
  }

  Widget _buttonFiveAble(double width, double height) {
    return Container(
        margin: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, height * 0.02),
        child: Row(
          children: <Widget>[
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508161921.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 0;
                    this._selectCoffeeIndex = 0;
                  });
                },
              ),
            ),
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508162004.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 6;
                    this._selectCoffeeIndex = 1;
                  });
                },
              ),
            ),
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508162007.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 12;
                    this._selectCoffeeIndex = 2;
                  });
                },
              ),
            ),
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508162011.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 18;
                    this._selectCoffeeIndex = 3;
                  });
                },
              ),
            ),
            Container(
                width: width * 0.15,
                height: height * 0.065,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  color: HexColor('e7e7e7'),
                ),
                child: Container(
                  child: IconButton(
                    icon: Container(
                      child: Image.asset('images/sozai_cman_jp_20210508161951.png'),
                    ),
                    onPressed: () {},
                  ),
                )
            ),
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508162016.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 30;
                    this._selectCoffeeIndex = 5;
                  });
                },
              ),
            ),
          ],
        )
    );
  }

  Widget _buttonSixAble(double width, double height) {
    return Container(
        margin: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, height * 0.02),
        child: Row(
          children: <Widget>[
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508161921.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 0;
                    this._selectCoffeeIndex = 0;
                  });
                },
              ),
            ),
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508162004.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 6;
                    this._selectCoffeeIndex = 1;
                  });
                },
              ),
            ),
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508162007.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 12;
                    this._selectCoffeeIndex = 2;
                  });
                },
              ),
            ),
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508162011.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 18;
                    this._selectCoffeeIndex = 3;
                  });
                },
              ),
            ),
            Container(
              width: width * 0.15,
              height: height * 0.065,
              child: IconButton(
                icon: Container(
                  child: Image.asset('images/sozai_cman_jp_20210508162013.png'),
                ),
                onPressed: () {
                  setState(() {
                    this._selectIndex = 24;
                    this._selectCoffeeIndex = 4;
                  });
                },
              ),
            ),
            Container(
                width: width * 0.15,
                height: height * 0.065,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  color: HexColor('e7e7e7'),
                ),
                child: Container(
                  child: IconButton(
                    icon: Container(
                      child: Image.asset('images/sozai_cman_jp_20210508161954.png'),
                    ),
                    onPressed: () {},
                  ),
                )
            ),
          ],
        )
    );
  }

  // カッピングしたデータをMap型に詰め直すメソッド1
  Map<String, dynamic> _setCuppingData() {
    Map<String, dynamic> cuppingData = new Map<String, dynamic>();

    cuppingData['coffee_name'] = _coffeeName;
    cuppingData['country'] = _selectedCountry;
    cuppingData['variety'] = _selectedVariety;
    if (_elevation == '') {
      cuppingData['elevation'] = 0;
    } else {
      cuppingData['elevation'] = int.parse(_elevation); // 数値型に変換
    }
    cuppingData['process'] = _selectedProcess;
    cuppingData['roaster'] = _roaster;
    cuppingData['sweetness'] = _sweetness;
    cuppingData['acidity'] = _acidity;
    cuppingData['mousefeel'] = _mouseFeel;
    cuppingData['aftertaste'] = _afterTaste;
    cuppingData['cleancup'] = _cleanCup;
    cuppingData['balance'] = _balance;
    cuppingData['flavor'] = _flavor;
    cuppingData['overall'] = _overall;
    cuppingData['flavor_text'] = _flavorText;
    cuppingData['comment'] = _comment;
    cuppingData['favorite'] = false;
    cuppingData['cupped_date'] = Timestamp.fromDate(DateTime.now());

    // 値が未入力だった場合
    if (cuppingData['coffee_name'] == '') {
      cuppingData['coffee_name'] = 'Some Coffee';
    }
    if (cuppingData['country'] == 'Country') {
      cuppingData['country'] = 'Some Country';
    }
    if (cuppingData['variety'] == 'Variety') {
      cuppingData['variety'] = 'Some Variety';
    }
    if (cuppingData['process'] == 'Process') {
      cuppingData['process'] = 'Some Process';
    }
    if (cuppingData['roaster'] == '') {
      cuppingData['roaster'] = 'Some Roaster';
    }
    if (cuppingData['flavor_text'] == '') {
      cuppingData['flavor_text'] = 'No Flavor Text';
    }
    if (cuppingData['comment'] == '') {
      cuppingData['comment'] = 'No Comment';
    }

    cuppingData['coffee_score'] =
      _cleanCup + _sweetness + _acidity + _mouseFeel + _afterTaste +
      _balance + _flavor + _overall + 36;
    return cuppingData;
  }

  // カッピングしたデータをMap型に詰め直すメソッド2
  Map<String, dynamic> _setCuppingDataSecond() {
    Map<String, dynamic> cuppingDataSecond = new Map<String, dynamic>();

    cuppingDataSecond['coffee_name'] = _coffeeNameSecond;
    cuppingDataSecond['country'] = _selectedCountrySecond;
    cuppingDataSecond['variety'] = _selectedVarietySecond;
    if (_elevationSecond == '') {
      cuppingDataSecond['elevation'] = 0;
    } else {
      cuppingDataSecond['elevation'] = int.parse(_elevationSecond); // 数値型に変換
    }
    cuppingDataSecond['process'] = _selectedProcessSecond;
    cuppingDataSecond['roaster'] = _roasterSecond;
    cuppingDataSecond['sweetness'] = _sweetnessSecond;
    cuppingDataSecond['acidity'] = _aciditySecond;
    cuppingDataSecond['mousefeel'] = _mouseFeelSecond;
    cuppingDataSecond['aftertaste'] = _afterTasteSecond;
    cuppingDataSecond['cleancup'] = _cleanCupSecond;
    cuppingDataSecond['balance'] = _balanceSecond;
    cuppingDataSecond['flavor'] = _flavorSecond;
    cuppingDataSecond['overall'] = _overallSecond;
    cuppingDataSecond['flavor_text'] = _flavorTextSecond;
    cuppingDataSecond['comment'] = _commentSecond;
    cuppingDataSecond['favorite'] = false;
    cuppingDataSecond['cupped_date'] = Timestamp.fromDate(DateTime.now());

    // 値が未入力だった場合
    if (cuppingDataSecond['coffee_name'] == '') {
      cuppingDataSecond['coffee_name'] = 'Some Coffee';
    }
    if (cuppingDataSecond['country'] == 'Country') {
      cuppingDataSecond['country'] = 'Some Country';
    }
    if (cuppingDataSecond['variety'] == 'Variety') {
      cuppingDataSecond['variety'] = 'Some Variety';
    }
    if (cuppingDataSecond['process'] == 'Process') {
      cuppingDataSecond['process'] = 'Some Process';
    }
    if (cuppingDataSecond['roaster'] == '') {
      cuppingDataSecond['roaster'] = 'Some Roaster';
    }
    if (cuppingDataSecond['flavor_text'] == '') {
      cuppingDataSecond['flavor_text'] = 'No Flavor Text';
    }
    if (cuppingDataSecond['comment'] == '') {
      cuppingDataSecond['comment'] = 'No Comment';
    }

    cuppingDataSecond['coffee_score'] =
        _cleanCupSecond + _sweetnessSecond + _aciditySecond + _mouseFeelSecond + _afterTasteSecond +
            _balanceSecond + _flavorSecond + _overallSecond + 36;
    return cuppingDataSecond;
  }

  // カッピングしたデータをMap型に詰め直すメソッド3
  Map<String, dynamic> _setCuppingDataThird() {
    Map<String, dynamic> cuppingDataSecond = new Map<String, dynamic>();

    cuppingDataSecond['coffee_name'] = _coffeeNameThird;
    cuppingDataSecond['country'] = _selectedCountryThird;
    cuppingDataSecond['variety'] = _selectedVarietyThird;
    if (_elevationThird == '') {
      cuppingDataSecond['elevation'] = 0;
    } else {
      cuppingDataSecond['elevation'] = int.parse(_elevationThird); // 数値型に変換
    }
    cuppingDataSecond['process'] = _selectedProcessThird;
    cuppingDataSecond['roaster'] = _roasterThird;
    cuppingDataSecond['sweetness'] = _sweetnessThird;
    cuppingDataSecond['acidity'] = _acidityThird;
    cuppingDataSecond['mousefeel'] = _mouseFeelThird;
    cuppingDataSecond['aftertaste'] = _afterTasteThird;
    cuppingDataSecond['cleancup'] = _cleanCupThird;
    cuppingDataSecond['balance'] = _balanceThird;
    cuppingDataSecond['flavor'] = _flavorThird;
    cuppingDataSecond['overall'] = _overallThird;
    cuppingDataSecond['flavor_text'] = _flavorTextThird;
    cuppingDataSecond['comment'] = _commentThird;
    cuppingDataSecond['favorite'] = false;
    cuppingDataSecond['cupped_date'] = Timestamp.fromDate(DateTime.now());

    // 値が未入力だった場合
    if (cuppingDataSecond['coffee_name'] == '') {
      cuppingDataSecond['coffee_name'] = 'Some Coffee';
    }
    if (cuppingDataSecond['country'] == 'Country') {
      cuppingDataSecond['country'] = 'Some Country';
    }
    if (cuppingDataSecond['variety'] == 'Variety') {
      cuppingDataSecond['variety'] = 'Some Variety';
    }
    if (cuppingDataSecond['process'] == 'Process') {
      cuppingDataSecond['process'] = 'Some Process';
    }
    if (cuppingDataSecond['roaster'] == '') {
      cuppingDataSecond['roaster'] = 'Some Roaster';
    }
    if (cuppingDataSecond['flavor_text'] == '') {
      cuppingDataSecond['flavor_text'] = 'No Flavor Text';
    }
    if (cuppingDataSecond['comment'] == '') {
      cuppingDataSecond['comment'] = 'No Comment';
    }

    cuppingDataSecond['coffee_score'] =
        _cleanCupThird + _sweetnessThird + _acidityThird + _mouseFeelThird + _afterTasteThird +
            _balanceThird + _flavorThird + _overallThird + 36;
    return cuppingDataSecond;
  }

  // カッピングしたデータをMap型に詰め直すメソッド4
  Map<String, dynamic> _setCuppingDataFourth() {
    Map<String, dynamic> cuppingDataSecond = new Map<String, dynamic>();

    cuppingDataSecond['coffee_name'] = _coffeeNameFourth;
    cuppingDataSecond['country'] = _selectedCountryFourth;
    cuppingDataSecond['variety'] = _selectedVarietyFourth;
    if (_elevationFourth == '') {
      cuppingDataSecond['elevation'] = 0;
    } else {
      cuppingDataSecond['elevation'] = int.parse(_elevationFourth); // 数値型に変換
    }
    cuppingDataSecond['process'] = _selectedProcessFourth;
    cuppingDataSecond['roaster'] = _roasterFourth;
    cuppingDataSecond['sweetness'] = _sweetnessFourth;
    cuppingDataSecond['acidity'] = _acidityFourth;
    cuppingDataSecond['mousefeel'] = _mouseFeelFourth;
    cuppingDataSecond['aftertaste'] = _afterTasteFourth;
    cuppingDataSecond['cleancup'] = _cleanCupFourth;
    cuppingDataSecond['balance'] = _balanceFourth;
    cuppingDataSecond['flavor'] = _flavorFourth;
    cuppingDataSecond['overall'] = _overallFourth;
    cuppingDataSecond['flavor_text'] = _flavorTextFourth;
    cuppingDataSecond['comment'] = _commentFourth;
    cuppingDataSecond['favorite'] = false;
    cuppingDataSecond['cupped_date'] = Timestamp.fromDate(DateTime.now());

    // 値が未入力だった場合
    if (cuppingDataSecond['coffee_name'] == '') {
      cuppingDataSecond['coffee_name'] = 'Some Coffee';
    }
    if (cuppingDataSecond['country'] == 'Country') {
      cuppingDataSecond['country'] = 'Some Country';
    }
    if (cuppingDataSecond['variety'] == 'Variety') {
      cuppingDataSecond['variety'] = 'Some Variety';
    }
    if (cuppingDataSecond['process'] == 'Process') {
      cuppingDataSecond['process'] = 'Some Process';
    }
    if (cuppingDataSecond['roaster'] == '') {
      cuppingDataSecond['roaster'] = 'Some Roaster';
    }
    if (cuppingDataSecond['flavor_text'] == '') {
      cuppingDataSecond['flavor_text'] = 'No Flavor Text';
    }
    if (cuppingDataSecond['comment'] == '') {
      cuppingDataSecond['comment'] = 'No Comment';
    }

    cuppingDataSecond['coffee_score'] =
        _cleanCupFourth + _sweetnessFourth + _acidityFourth + _mouseFeelFourth + _afterTasteFourth +
            _balanceFourth + _flavorFourth + _overallFourth + 36;
    return cuppingDataSecond;
  }

  // カッピングしたデータをMap型に詰め直すメソッド5
  Map<String, dynamic> _setCuppingDataFifth() {
    Map<String, dynamic> cuppingDataSecond = new Map<String, dynamic>();

    cuppingDataSecond['coffee_name'] = _coffeeNameFifth;
    cuppingDataSecond['country'] = _selectedCountryFifth;
    cuppingDataSecond['variety'] = _selectedVarietyFifth;
    if (_elevationFifth == '') {
      cuppingDataSecond['elevation'] = 0;
    } else {
      cuppingDataSecond['elevation'] = int.parse(_elevationFifth); // 数値型に変換
    }
    cuppingDataSecond['process'] = _selectedProcessFifth;
    cuppingDataSecond['roaster'] = _roasterFifth;
    cuppingDataSecond['sweetness'] = _sweetnessFifth;
    cuppingDataSecond['acidity'] = _acidityFifth;
    cuppingDataSecond['mousefeel'] = _mouseFeelFifth;
    cuppingDataSecond['aftertaste'] = _afterTasteFifth;
    cuppingDataSecond['cleancup'] = _cleanCupFifth;
    cuppingDataSecond['balance'] = _balanceFifth;
    cuppingDataSecond['flavor'] = _flavorFifth;
    cuppingDataSecond['overall'] = _overallFifth;
    cuppingDataSecond['flavor_text'] = _flavorTextFifth;
    cuppingDataSecond['comment'] = _commentFifth;
    cuppingDataSecond['favorite'] = false;
    cuppingDataSecond['cupped_date'] = Timestamp.fromDate(DateTime.now());

    // 値が未入力だった場合
    if (cuppingDataSecond['coffee_name'] == '') {
      cuppingDataSecond['coffee_name'] = 'Some Coffee';
    }
    if (cuppingDataSecond['country'] == 'Country') {
      cuppingDataSecond['country'] = 'Some Country';
    }
    if (cuppingDataSecond['variety'] == 'Variety') {
      cuppingDataSecond['variety'] = 'Some Variety';
    }
    if (cuppingDataSecond['process'] == 'Process') {
      cuppingDataSecond['process'] = 'Some Process';
    }
    if (cuppingDataSecond['roaster'] == '') {
      cuppingDataSecond['roaster'] = 'Some Roaster';
    }
    if (cuppingDataSecond['flavor_text'] == '') {
      cuppingDataSecond['flavor_text'] = 'No Flavor Text';
    }
    if (cuppingDataSecond['comment'] == '') {
      cuppingDataSecond['comment'] = 'No Comment';
    }

    cuppingDataSecond['coffee_score'] =
        _cleanCupFifth + _sweetnessFifth + _acidityFifth + _mouseFeelFifth + _afterTasteFifth +
            _balanceFifth + _flavorFifth + _overallFifth + 36;
    return cuppingDataSecond;
  }

  // カッピングしたデータをMap型に詰め直すメソッド6
  Map<String, dynamic> _setCuppingDataSixth() {
    Map<String, dynamic> cuppingDataSecond = new Map<String, dynamic>();

    cuppingDataSecond['coffee_name'] = _coffeeNameSixth;
    cuppingDataSecond['country'] = _selectedCountrySixth;
    cuppingDataSecond['variety'] = _selectedVarietySixth;
    if (_elevationSixth == '') {
      cuppingDataSecond['elevation'] = 0;
    } else {
      cuppingDataSecond['elevation'] = int.parse(_elevationSixth); // 数値型に変換
    }
    cuppingDataSecond['process'] = _selectedProcessSixth;
    cuppingDataSecond['roaster'] = _roasterSixth;
    cuppingDataSecond['sweetness'] = _sweetnessSixth;
    cuppingDataSecond['acidity'] = _aciditySixth;
    cuppingDataSecond['mousefeel'] = _mouseFeelSixth;
    cuppingDataSecond['aftertaste'] = _afterTasteSixth;
    cuppingDataSecond['cleancup'] = _cleanCupSixth;
    cuppingDataSecond['balance'] = _balanceSixth;
    cuppingDataSecond['flavor'] = _flavorSixth;
    cuppingDataSecond['overall'] = _overallSixth;
    cuppingDataSecond['flavor_text'] = _flavorTextSixth;
    cuppingDataSecond['comment'] = _commentSixth;
    cuppingDataSecond['favorite'] = false;
    cuppingDataSecond['cupped_date'] = Timestamp.fromDate(DateTime.now());

    // 値が未入力だった場合
    if (cuppingDataSecond['coffee_name'] == '') {
      cuppingDataSecond['coffee_name'] = 'Some Coffee';
    }
    if (cuppingDataSecond['country'] == 'Country') {
      cuppingDataSecond['country'] = 'Some Country';
    }
    if (cuppingDataSecond['variety'] == 'Variety') {
      cuppingDataSecond['variety'] = 'Some Variety';
    }
    if (cuppingDataSecond['process'] == 'Process') {
      cuppingDataSecond['process'] = 'Some Process';
    }
    if (cuppingDataSecond['roaster'] == '') {
      cuppingDataSecond['roaster'] = 'Some Roaster';
    }
    if (cuppingDataSecond['flavor_text'] == '') {
      cuppingDataSecond['flavor_text'] = 'No Flavor Text';
    }
    if (cuppingDataSecond['comment'] == '') {
      cuppingDataSecond['comment'] = 'No Comment';
    }

    cuppingDataSecond['coffee_score'] =
        _cleanCupSixth + _sweetnessSixth + _aciditySixth + _mouseFeelSixth + _afterTasteSixth +
            _balanceSixth + _flavorSixth + _overallSixth + 36;
    return cuppingDataSecond;
  }

  // Firestoreにデータを登録するメソッド
  void _writeCuppingData(Map<String, dynamic> cuppingData, String uid) async {
    await FirebaseFirestore.instance
        .collection('CuppedCoffee')
        .doc(uid)
        .collection('CoffeeInfo')
        .add(cuppingData);
  }

  // タイマー
  void _onTimer(Timer timer) {
    if (_countSecond < 59) {
      setState(() {
        this._countSecond++;
      });

      if (this._countSecond <= 9) {
        setState(() {
          this._countSecondStr = '0${this._countSecond}';
        });
      } else {
        setState(() {
          this._countSecondStr = '${this._countSecond}';
        });
      }
    } else {
      setState(() {
        this._countSecond = 0;
        this._countSecondStr = '00';
        this._countMinute++;
      });

      if (this._countMinute <= 9) {
        setState(() {
          this._countMinuteStr = '0${this._countMinute}';
        });
      } else {
        setState(() {
          this._countMinuteStr = '${this._countMinute}';
        });
      }
    }
  }

  // タイマーをリセットするメソッド
  void _resetTimer() {
    setState(() {
      this._countMinute = 0;
      this._countSecond = 0;
      this._countSecondStr = '00';
    });
  }

  Widget _pickerItem(String str) {
    return Text(
      str,
      style: const TextStyle(fontSize: 26),
    );
  }

  void _onSelectedItemChanged(int index) {
    setState(() {
      _selectedCountry = _countries[index];
    });
  }

  void _showModalCountriesPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _countries.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedItemChanged,
              scrollController: FixedExtentScrollController(
                initialItem: _countries.indexOf(_selectedCountry),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSelectedItemChangedSecond(int index) {
    setState(() {
      _selectedCountrySecond = _countriesSecond[index];
    });
  }

  void _showModalCountriesPickerSecond(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _countriesSecond.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedItemChangedSecond,
              scrollController: FixedExtentScrollController(
                initialItem: _countriesSecond.indexOf(_selectedCountrySecond),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSelectedItemChangedThird(int index) {
    setState(() {
      _selectedCountryThird = _countriesThird[index];
    });
  }

  void _showModalCountriesPickerThird(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _countriesThird.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedItemChangedThird,
              scrollController: FixedExtentScrollController(
                initialItem: _countriesThird.indexOf(_selectedCountryThird),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSelectedItemChangedFourth(int index) {
    setState(() {
      _selectedCountryFourth = _countriesFourth[index];
    });
  }

  void _showModalCountriesPickerFourth(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _countriesFourth.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedItemChangedFourth,
              scrollController: FixedExtentScrollController(
                initialItem: _countriesFourth.indexOf(_selectedCountryFourth),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSelectedItemChangedFifth(int index) {
    setState(() {
      _selectedCountryFifth = _countriesFifth[index];
    });
  }

  void _showModalCountriesPickerFifth(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _countriesFifth.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedItemChangedFifth,
              scrollController: FixedExtentScrollController(
                initialItem: _countriesFifth.indexOf(_selectedCountryFifth),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSelectedItemChangedSixth(int index) {
    setState(() {
      _selectedCountrySixth = _countriesSixth[index];
    });
  }

  void _showModalCountriesPickerSixth(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _countriesSixth.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedItemChangedSixth,
              scrollController: FixedExtentScrollController(
                initialItem: _countriesSixth.indexOf(_selectedCountrySixth),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSelectedVarietyChanged(int index) {
    setState(() {
      _selectedVariety = _varieties[index];
    });
  }

  void _showModalVarietiesPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _varieties.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedVarietyChanged,
              scrollController: FixedExtentScrollController(
                initialItem: _varieties.indexOf(_selectedVariety),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSelectedVarietyChangedSecond(int index) {
    setState(() {
      _selectedVarietySecond = _varietiesSecond[index];
    });
  }

  void _showModalVarietiesPickerSecond(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _varietiesSecond.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedVarietyChangedSecond,
              scrollController: FixedExtentScrollController(
                initialItem: _varietiesSecond.indexOf(_selectedVarietySecond),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSelectedVarietyChangedThird(int index) {
    setState(() {
      _selectedVarietyThird = _varietiesThird[index];
    });
  }

  void _showModalVarietiesPickerThird(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _varietiesThird.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedVarietyChangedThird,
              scrollController: FixedExtentScrollController(
                initialItem: _varietiesThird.indexOf(_selectedVarietyThird),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSelectedVarietyChangedFourth(int index) {
    setState(() {
      _selectedVarietyFourth = _varietiesFourth[index];
    });
  }

  void _showModalVarietiesPickerFourth(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _varietiesFourth.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedVarietyChangedFourth,
              scrollController: FixedExtentScrollController(
                initialItem: _varietiesFourth.indexOf(_selectedVarietyFourth),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSelectedVarietyChangedFifth(int index) {
    setState(() {
      _selectedVarietyFifth = _varietiesFifth[index];
    });
  }

  void _showModalVarietiesPickerFifth(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _varietiesFifth.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedVarietyChangedFifth,
              scrollController: FixedExtentScrollController(
                initialItem: _varietiesFifth.indexOf(_selectedVarietyFifth),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSelectedVarietyChangedSixth(int index) {
    setState(() {
      _selectedVarietySixth = _varietiesSixth[index];
    });
  }

  void _showModalVarietiesPickerSixth(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _varietiesSixth.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedVarietyChangedSixth,
              scrollController: FixedExtentScrollController(
                initialItem: _varietiesSixth.indexOf(_selectedVarietySixth),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSelectedProcessChanged(int index) {
    setState(() {
      _selectedProcess = _processes[index];
    });
  }

  void _showModalProcessesPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _processes.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedProcessChanged,
              scrollController: FixedExtentScrollController(
                initialItem: _processes.indexOf(_selectedProcess),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSelectedProcessChangedSecond(int index) {
    setState(() {
      _selectedProcessSecond = _processesSecond[index];
    });
  }

  void _showModalProcessesPickerSecond(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _processesSecond.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedProcessChangedSecond,
              scrollController: FixedExtentScrollController(
                initialItem: _processesSecond.indexOf(_selectedProcessSecond),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSelectedProcessChangedThird(int index) {
    setState(() {
      _selectedProcessThird = _processesThird[index];
    });
  }

  void _showModalProcessesPickerThird(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _processesThird.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedProcessChangedThird,
              scrollController: FixedExtentScrollController(
                initialItem: _processesThird.indexOf(_selectedProcessThird),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSelectedProcessChangedFourth(int index) {
    setState(() {
      _selectedProcessFourth = _processesFourth[index];
    });
  }

  void _showModalProcessesPickerFourth(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _processesFourth.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedProcessChangedFourth,
              scrollController: FixedExtentScrollController(
                initialItem: _processesFourth.indexOf(_selectedProcessFourth),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSelectedProcessChangedFifth(int index) {
    setState(() {
      _selectedProcessFifth = _processesFifth[index];
    });
  }

  void _showModalProcessesPickerFifth(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _processesFifth.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedProcessChangedFifth,
              scrollController: FixedExtentScrollController(
                initialItem: _processesFifth.indexOf(_selectedProcessFifth),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSelectedProcessChangedSixth(int index) {
    setState(() {
      _selectedProcessSixth = _processesSixth[index];
    });
  }

  void _showModalProcessesPickerSixth(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CupertinoPicker(
              itemExtent: 40,
              children: _processesSixth.map(_pickerItem).toList(),
              onSelectedItemChanged: _onSelectedProcessChangedSixth,
              scrollController: FixedExtentScrollController(
                initialItem: _processesSixth.indexOf(_selectedProcessSixth),
              ),
            ),
          ),
        );
      },
    );
  }
}

// カラーコードで色を表示するためのクラス
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
