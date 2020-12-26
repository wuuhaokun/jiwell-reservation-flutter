import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
import 'dart:async';
import 'package:jiwell_reservation/models/hot_entity.dart';
import 'package:jiwell_reservation/models/new/spu_search_entity.dart';
import '../../utils/config.dart';

class SpuSearchDao{
  static Future<SpuSearchEntity> fetch(String key, String token) async{
    const String SEAECH_URL = '$JIWELL_SERVER_HOST/search/page';
    try {
      final Map<String,dynamic> map = {'key':key,'page':1,'sortBy':'','descending':false,'filter':{'key':''}};
      //String str = '{"key":"华为","page":1,"sortBy":"","descending":false,"filter":{"key":""}}';
      //Map<String,dynamic> map1 = json.decode(str);
      final Response response = await Dio().post(SEAECH_URL,data: map);
      if(response.statusCode == 200){
        final Map<String,dynamic>dataMap = {'data':response.data};
        return EntityFactory.generateOBJ<SpuSearchEntity>(dataMap);
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}