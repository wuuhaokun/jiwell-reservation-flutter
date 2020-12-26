import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/msg_entity.dart';
// ignore: directives_ordering
import 'dart:async';
import '../utils/config.dart';
import 'package:jiwell_reservation/common.dart';

const SAVE_PWD_URL = '$JIWELL_SERVER_HOST/user/password';

class SavePwdDao{

  static Future<bool> fetch(String oldPwd,String pwd,String rePassword,String token) async{
    try {
      final String headerToken = 'Bearer '+ token;
      final Map<String,String> map={'Authorization':headerToken};
      final Options options = Options(headers:map);
      final Map<String,dynamic> paramMap = {'account':AppConfig.mobile,'oldPassword':oldPwd,'newPassword':pwd};
      final Response response = await Dio().post(SAVE_PWD_URL,
          options: options,queryParameters: paramMap);
      if(response.statusCode == 200){
        return true;
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

}




