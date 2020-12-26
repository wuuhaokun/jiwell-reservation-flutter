import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/login_entity.dart';
// ignore: directives_ordering
import 'dart:async';

import '../utils/config.dart';

//const String LOGIN_REG_URL = '$SERVER_HOST/loginOrReg';
class LoginRegDao{

  static Future<LoginEntity> fetch(String account,String password) async{
    try {
      const String LOGIN_REG_URL = '$JIWELL_SERVER_HOST/auth/accredit/code';
      final Map<String,dynamic> map = {'account':account,'password':password};

      final Response response = await Dio().post(LOGIN_REG_URL,queryParameters: map);
      if(response.statusCode == 200){
        return EntityFactory.generateOBJ<LoginEntity>(response.data);
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}




