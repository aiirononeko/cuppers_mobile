import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MyFirebaseStorage {

  // Storageからプロフィール画像を取得するメソッド
  static Future<Image> downloadFile(String uid) async {

    StorageReference ref = FirebaseStorage().ref().child(uid);

    try {

      final String url = await ref.getDownloadURL();
      final Image img = new Image(image: new CachedNetworkImageProvider(url));

      return img;

    } catch(e) {

      // TODO エラーハンドリング実装
      return null;
    }
  }
}
