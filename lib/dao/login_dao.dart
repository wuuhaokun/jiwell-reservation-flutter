import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/login_entity.dart';
// ignore: directives_ordering
import 'dart:async';
import '../utils/config.dart';
//const LOGIN_URL = '$SERVER_HOST/loginByPass';

const String LOGIN_URL = '$JIWELL_SERVER_HOST/auth/accredit';
const String VERIFY_URL = '$JIWELL_SERVER_HOST/auth/verify';

class LoginDao{

  static Future<LoginEntity> fetch(String account,String password) async{
    try {
      Map<String,dynamic> map ={'account':account,'password':password};
      // ignore: always_specify_types
      final Response response = await Dio().post(LOGIN_URL,queryParameters: map);
      if(response.statusCode == 200){
        return EntityFactory.generateOBJ<LoginEntity>(response.data);
        //return true;
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
        //return false;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> verify() async{
    try {
      Response response = await Dio().get(VERIFY_URL);
      if(response.statusCode == 200){
        return true;
      }else{
        return false;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
  ///http://{{Domain}}{{AuthItem}}/verify

}




