import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/new/buy_type_entity.dart';
import 'package:jiwell_reservation/models/new/spus_entity.dart';
import 'package:jiwell_reservation/utils/config.dart';


class FavoriteDao{

  static Future<SpusEntity> listFetch(String token, String userId) async{
    const String FAVORITE_URL = '$JIWELL_SERVER_HOST/favorite/collection/';
    try {
      final String headerToken = 'Bearer '+ token;
      final RequestOptions options = RequestOptions(headers: {'Authorization':headerToken,'content-type':'application/json'},connectTimeout: 5000);
      final Response response = await Dio().get(FAVORITE_URL+userId,options: options);
      if(response.statusCode == 200){
        final Map<String,dynamic> map = {'items':response.data};
        return EntityFactory.generateOBJ<SpusEntity>(map);
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> saveFetch(String token, int userId,int spuId) async{
    const String FAVORITE_URL = '$JIWELL_SERVER_HOST/favorite/collection/';
    try {
      final String headerToken = 'Bearer '+ token;
      final RequestOptions options = RequestOptions(headers: {'Authorization':headerToken,'content-type':'application/json'},connectTimeout: 5000);
      Map<String,dynamic> params ={'userId':userId,'spuId':spuId};
      final Response response = await Dio().post(FAVORITE_URL,options: options,data:json.encode(params));
      if(response.statusCode == 200 || response.statusCode == 201){
        return true;
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> deleteFetch(String token, int userId,int spuId) async{
    const String FAVORITE_URL = '$JIWELL_SERVER_HOST/favorite/collection/';
    try {
      final String headerToken = 'Bearer '+ token;
      final RequestOptions options = RequestOptions(headers: {'Authorization':headerToken,'content-type':'application/json'},connectTimeout: 5000);
      Map<String,dynamic> params ={'userId':userId,'spuId':spuId};
      final Response response = await Dio().delete(FAVORITE_URL,options: options,data:json.encode(params));
      if(response.statusCode == 200){
        return true;
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> isFavoriteFetch(String token, int userId,int spuId) async{
    const String FAVORITE_URL = '$JIWELL_SERVER_HOST/favorite/collection/isCollection/';
    try {
      final String headerToken = 'Bearer '+ token;
      final RequestOptions options = RequestOptions(headers: {'Authorization':headerToken,'content-type':'application/json'},connectTimeout: 5000);
      //Map<String,dynamic> params ={'userId':userId,'spuId':spuId};
      final Response response = await Dio().get(FAVORITE_URL + spuId.toString(),options: options);
      if(response.statusCode == 200){
        return true;
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

}