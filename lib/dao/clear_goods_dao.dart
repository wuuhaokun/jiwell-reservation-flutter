import 'package:dio/dio.dart';

import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/msg_entity.dart';
import 'dart:async';
import '../utils/config.dart';
//const CLEAR_URL = '$SERVER_HOST/user/cart';
const String CLEAR_URL = '$JIWELL_SERVER_HOST/cart/';

class ClearDao{

  static Future<MsgEntity> fetch(String id,String token) async{
    try {
      final String headerToken = 'Bearer '+ token;
      // ignore: always_specify_types
      final Options options = Options(headers: {'Authorization':headerToken});
      // ignore: always_specify_types
      final Response response = await Dio().delete(CLEAR_URL + id,
          //queryParameters: {"id":id},
          options: options);
      if(response.statusCode == 200){
        return EntityFactory.generateOBJ<MsgEntity>(response.data);
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> fetch1(String id,String token) async{
    try {
      final String headerToken = 'Bearer '+ token;
      // ignore: always_specify_types
      final Options options = Options(headers: {'Authorization':headerToken});
      // ignore: always_specify_types
      final Response response = await Dio().delete(CLEAR_URL + id,
          options: options);
      if(response.statusCode == 200){
        return true;
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}




