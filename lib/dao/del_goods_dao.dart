import 'package:dio/dio.dart';

import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/msg_entity.dart';
import 'dart:async';
import '../utils/config.dart';
//const DEL_URL = '$SERVER_HOST/user/cart/update';
const String DEL_URL = '$JIWELL_SERVER_HOST/cart';

class DelDao{

  static Future<MsgEntity> fetch(String id,int count,String token) async{
    try {
      // ignore: always_specify_types
      final Options options = Options(headers: {'Authorization':token});
      // ignore: always_specify_types
      final Response response = await Dio().post(DEL_URL+'/'+id+'/'+count.toString(),
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
    String DEL_URL = '$JIWELL_SERVER_HOST/cart/';
    try {
      final String headerToken = 'Bearer '+ token;
      // ignore: always_specify_types
      final Options options = Options(headers: {'Authorization':headerToken});
      final Response response = await Dio().delete(DEL_URL + id, options: options);
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




