import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/cart_goods_query_entity.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/new/cart_goods_entity.dart';

// ignore: directives_ordering
import 'dart:async';

import '../utils/config.dart';

class CartQueryDao{

  static Future<CartGoodsQueryEntity> fetch(String token) async{
    const String CART_URL = '$JIWELL_SERVER_HOST/cart';
    try {
      final String headerToken = 'Bearer '+ token;
      final Options options = Options(headers: {'Authorization':headerToken});
      final Response response = await Dio().get(CART_URL,options: options);
      if(response.statusCode == 200){
        final Map<String,dynamic> map = {'data':response.data};
        return EntityFactory.generateOBJ<CartGoodsQueryEntity>(map);
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<CartGoodsQueryEntity> fetch1(String token) async{
    const String CART_URL = '$JIWELL_SERVER_HOST/cart';
    try {
      final String headerToken = 'Bearer '+ token;
      //final Options options = Options(headers: {'Authorization':headerToken});
      final RequestOptions options = RequestOptions(headers: {'Authorization':headerToken},connectTimeout: 5000);
      final Response response = await Dio().get(CART_URL,options: options);
      if(response.statusCode == 200){
        final Map<String,dynamic> map = {'data':response.data};
        return EntityFactory.generateOBJ<CartGoodsQueryEntity>(map);
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}