
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpressionUtils{

  // static Widget getCachedNetworkImage(String imgUrl, BoxFit fit , String defaultImage){
  //   return CachedNetworkImage(
  //       imageUrl: '',//imgUrl,
  //       placeholder: (context, url) => Image.asset((defaultImage??'images/default.png')),
  //       //errorWidget: (context, url, error) => new Icon(Icons.error),
  //       fit: (fit??BoxFit.cover)
  //   );
  // }


  //電話號碼：09開頭，後面8位數字
  static bool isPhone(String input) {
    RegExp exp = RegExp(
        r'^(09[0-9])\d{7}$');
    bool matched = exp.hasMatch(input);
    return matched;
  }

  //登錄密碼：6~16位數字和字符組合
  static bool isLoginPassword(String input) {
    RegExp mobile = new RegExp(r"(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$");
    return mobile.hasMatch(input);
  }

  //登錄密碼：6位數字驗證碼
  static bool isValidateCaptcha(String input) {
    RegExp mobile = new RegExp(r"\d{6}$");
    return mobile.hasMatch(input);
  }

  //台灣身份證驗証
  static bool isCardId(String cardId) {
    bool checkPid(id) {
      String tab = "ABCDEFGHJKLMNPQRSTUVWXYZIO";
      List A1 = [
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
        3, 3, 3, 3, 3, 3
      ];
      List A2 = [
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
        2, 0, 1, 3, 4, 5
      ];
      List Mx = [9, 8, 7, 6, 5, 4, 3, 2, 1, 1];
      if (id.length != 10) return false;
      int i = tab.indexOf(id.substring(0, 1));

      if (i == -1) return false;
      int sum = A1[i] + A2[i] * 9;

      for (int j = 1; j < 10; j++) {
        if (!_isNumeric(id.substring(j, j + 1))) return false;
        int v = int.parse(id.substring(j, j + 1));
        if (v.runtimeType != int) return false;
        sum = sum + v * Mx[j];
      }
      if (sum % 10 != 0) return false;
      return true;
    }
  }

  static bool _isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  /// 檢查是否是郵箱格式
  bool isEmail(String input) {
    final String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)* \$";
    if (input == null || input.isEmpty) return false;
    return new RegExp(regexEmail).hasMatch(input);
  }

}


