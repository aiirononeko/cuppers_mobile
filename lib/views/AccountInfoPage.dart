import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuppers_mobile/services/HexColor.dart';
import 'package:cuppers_mobile/views/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'RegistrationPage.dart';

class AccountInfoPage extends StatefulWidget {

  @override
  _AccountInfoPageState createState() => _AccountInfoPageState();
}

// アカウント情報表示画面
class _AccountInfoPageState extends State<AccountInfoPage> {

  final _focusNode = FocusNode();

  File _image;
  final picker = ImagePicker();

  final _uid = FirebaseAuth.instance.currentUser.uid;

  String _userName;
  TextEditingController _userNameController;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        fetchUserName();
      }
    });

    _getUserName().then((_) {
      _userNameController = new TextEditingController(text: _userName);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _userNameChanged(String str) => setState(() { _userName = str; });

  @override
  Widget build(BuildContext context) {

    // 画面サイズを取得
    final Size size = MediaQuery.of(context).size;
    final double _width = size.width;
    final double _height = size.height;

    return Scaffold(
        appBar: AppBar(
          title: Container(
            height: _height * 0.025,
            margin: EdgeInsets.fromLTRB(0, _height * 0.01, 0, 0),
            child: Image.asset('images/cuppers_logo_apart-05.png'),
          ),
          backgroundColor: Colors.white24,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(_height * 0.08),
            child:  AppBar(
              title: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: _width * 0.35,
                        height: _height * 0.035,
                      ),
                      Container(
                        width: _width * 0.1,
                      ),
                      Container(
                        height: _height * 0.05,
                      ),
                    ],
                  ),
                ],
              ),
              backgroundColor: Colors.white24,
              elevation: 0.0,
              iconTheme: IconThemeData(color: Colors.black),
            ),
          ),
        ),
        body: _accountPage(_width, _height, context),
    );
  }

  Widget _accountPage(double width, double height, BuildContext context) {

    // ユーザーが匿名ユーザーか否かを判定
    if (FirebaseAuth.instance.currentUser.isAnonymous) {

      // 匿名ユーザーの場合
      return Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Divider(
                color: HexColor('313131'),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(width * 0.05, height * 0.015, 0, height * 0.015),
              child: Text(
                'アカウント',
                style: TextStyle(
                  fontSize: height * 0.013
                ),
              ),
            ),
            InkWell(
              onTap: () {

                // ユーザー登録画面に遷移
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrationPage()
                    )
                );
              },
              child: Container(
                width: width,
                height: height * 0.06,
                color: HexColor('e7e7e7'),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.05, 0, 0, 0),
                      child: Text(
                        'ユーザー登録',
                        style: TextStyle(
                            fontSize: height * 0.015
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(width * 0.63, 0, 0, 0),
                      child: Icon(Icons.navigate_next),
                    )
                  ],
                )
              ),
            )
          ],
        )
      );
    } else {

      // 匿名ユーザーでない場合
      return Container(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Divider(
                  color: HexColor('313131'),
                ),
              ),
              _userImageWidget(width, height),
              Container(
                margin: EdgeInsets.fromLTRB(width * 0.2, 0, width * 0.2, height * 0.03),
                child: TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    labelText: 'ユーザーネーム',
                    hintText: 'カッピング太郎',
                  ),
                  style: TextStyle(
                      fontSize: height * 0.02
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: _userNameChanged,
                  textInputAction: TextInputAction.done,
                  focusNode: _focusNode,
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(width * 0.05, height * 0.015, 0, height * 0.015),
                child: Text(
                  'アカウント',
                  style: TextStyle(
                      fontSize: height * 0.013
                  ),
                ),
              ),
              InkWell(
                onTap: () async {

                  // サインアウト
                  await FirebaseAuth.instance.signOut();

                  // ログインページに遷移
                  Navigator.pushAndRemoveUntil(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new LoginPage()),
                          (_) => false);
                },
                child: Container(
                    width: width,
                    height: height * 0.06,
                    color: HexColor('e7e7e7'),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(width * 0.05, 0, 0, 0),
                          child: Text(
                            'ログアウト',
                            style: TextStyle(
                                fontSize: height * 0.015
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(width * 0.63, 0, 0, 0),
                          child: Icon(Icons.navigate_next),
                        )
                      ],
                    )
                ),
              )
            ],
          )
      );
    }
  }

  Widget _userImageWidget(double width, double height) {

    if (_image != null) {

      return InkWell(
        onTap: () {
          getImageFromGallery();
        },
        child: Container(
          width: width * 0.45,
          height: height * 0.3,
          decoration: BoxDecoration(
            // border: Border.all(color: HexColor('313131')),
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: Image.file(_image).image
              )
          ),
        ),
      );
    } else {

      return InkWell(
        onTap: () {
          getImageFromGallery();
        },
        child: Container(
          width: width * 0.45,
          height: height * 0.3,
          decoration: BoxDecoration(
            border: Border.all(color: HexColor('313131')),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '画像を選択してください',
              style: TextStyle(
                  color: HexColor('313131')
              ),
            ),
          )
        ),
      );
    }
  }

  // ギャラリーから画像を取得するメソッド
  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  // ユーザーネームを取得するメソッド
  Future _getUserName() async {

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(this._uid)
        .get();

    setState(() {
      if (snapshot.data()['name'] != null) {
        _userName = snapshot.data()['name'];
      } else {
        _userName = '';
      }
    });
  }

  // ユーザーネームを登録するメソッド
  void fetchUserName() async {

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(_uid)
        .update({ 'name': _userName });
  }
}
