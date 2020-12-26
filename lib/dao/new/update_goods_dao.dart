import 'package:dio/dio.dart';

import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/msg_entity.dart';
import 'dart:async';

import 'package:jiwell_reservation/utils/config.dart';

//const DEL_URL = '$SERVER_HOST/user/cart/update';


class updateDao{

  static Future<MsgEntity> fetch(String id,int count,String token) async{
    const String UPDATE_URL = '$JIWELL_SERVER_HOST/cart';
    try {
      final Options options = Options(headers: {'Authorization':token});
      final Response response = await Dio().post(UPDATE_URL+'/'+id+'/'+count.toString(),
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

  static Future<bool> fetch1(String id,int count,String token) async{
    const String UPDATE_URL = '$JIWELL_SERVER_HOST/cart';
    try {
      final String headerToken = 'Bearer '+ token;
      final Options options = Options(headers: {'Authorization':headerToken});
      final Response response = await Dio().put(UPDATE_URL,queryParameters: {'skuId':id,'num':count},
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




