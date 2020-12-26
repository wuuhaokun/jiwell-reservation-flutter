import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/login_entity.dart';
import 'package:jiwell_reservation/models/user_entity.dart';
// ignore: directives_ordering
import 'dart:async';

import '../utils/config.dart';
//const USER_URL = '$SERVER_HOST/user/getInfo';
const String USER_URL = '$JIWELL_SERVER_HOST/auth/verify1';
class UserDao{

  static Future<UserEntity> fetch(String token) async{
    try {
      //Bearer
      final String headerToken = 'Bearer '+ token;
      final RequestOptions options = RequestOptions(headers: {'Authorization':headerToken},connectTimeout: 5000);
      //final RequestOptions options = RequestOptions(/*headers: {'Authorization':token,'content-type':'application/json'},*/connectTimeout: 5000);
      // ignore: always_specify_types
      final Response response = await Dio().get(USER_URL,options: options);
      if(response.statusCode == 200){
        // ignore: always_specify_types
        final Map<String,dynamic> dataMap = {'data':response.data};
        return EntityFactory.generateOBJ<UserEntity>(dataMap);
      }else if(response.statusCode == 403){
        UserEntity userEntity = new UserEntity();
        userEntity.statusCode = 403;
        return userEntity;
      }
      else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      UserEntity userEntity = new UserEntity();
      userEntity.statusCode = 500;
      return userEntity;
      print(e);
      return null;
    }
  }

}




