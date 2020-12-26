import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
// ignore: directives_ordering
import 'dart:async';
import 'package:jiwell_reservation/models/hot_entity.dart';
import '../utils/config.dart';

const String SEAECH_URL = '$JIWELL_SERVER_HOST/search/page1';
class SearchDao{
  //华为
  static Future<SearchEntity> fetch(String key, String token) async{
    try {
      //Map<String,dynamic> filterMap = {'key':'price'};
      // ignore: always_specify_types
      final Map<String,dynamic> map = {'key':key,'page':1,'sortBy':'','descending':false,'filter':{'key':''}};
      //String str = '{"key":"华为","page":1,"sortBy":"","descending":false,"filter":{"key":""}}';
      //Map<String,dynamic> map1 = json.decode(str);
      final Response response = await Dio().post(SEAECH_URL,queryParameters: map);
      if(response.statusCode == 200){
        // ignore: always_specify_types
        final Map<String,dynamic>dataMap = {'data':response.data};
        return EntityFactory.generateOBJ<SearchEntity>(dataMap);
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}