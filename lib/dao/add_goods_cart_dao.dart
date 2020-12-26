import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/cart_entity.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
// ignore: directives_ordering
import 'dart:async';

import '../common.dart';
import '../utils/config.dart';

const String ADD_URL = '$JIWELL_SERVER_HOST/cart';

class AddDao{
  static Future<CartEntity> fetch(String title,int count,String idSku,double price,String image,String ownSpec,String token) async{
    try {
      final String headerToken = 'Bearer '+ token;
      final Options options = Options(headers: {'Authorization':headerToken});
      //widget.id, 1, model.id, AppConfig.token
      // ignore: always_specify_types
      final Map<String, dynamic> param = {'userId':AppConfig.userId,'skuId':idSku,'title':title,'price': price,
          'num': count,'image':'','ownSpec':ownSpec};
      // ignore: always_specify_types
      final Response response = await Dio().post(ADD_URL,
          data:json.encode(param),
          options: options);
      if(response.statusCode == 200){
        return EntityFactory.generateOBJ<CartEntity>(response.data);
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> fetch1(String title,int count,String idSku,double price,String image,String ownSpec,String description,String token) async{
    try {
      final String headerToken = 'Bearer '+ token;
      final Options options = Options(headers: {'Authorization':headerToken});
      final Map<String, dynamic> param = {'userId':AppConfig.userId,'skuId':idSku,'title':title,'price': price,
        'num': count,'image':image,'ownSpec':ownSpec,'description':description};
      final Response response = await Dio().post(ADD_URL,
          data:json.encode(param),
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




