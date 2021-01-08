import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/new/comment_entity.dart';
import 'package:jiwell_reservation/utils/config.dart';


class CommentDao{

  static Future<CommentEntity> listFetch(String token, int spuId) async{
    const String comment_Url = '$JIWELL_SERVER_HOST/review/list1';
    try {
      final String headerToken = 'Bearer '+ token;
      final RequestOptions options = RequestOptions(headers: {'Authorization':headerToken},connectTimeout: 5000);

      final Map<String,dynamic> map = {"spuId":57,"page":1};//{"spuId":57,"page":1}
      //private static final Integer DEFAULT_SIZE = 20;
      //private static final Integer DEFAULT_PAGE = 1;
      final Response response = await Dio().get(comment_Url,queryParameters: map,options: options);
      // final Map<String,dynamic> map = {"spuId":spuId,"page":1};
      // final Response response = await Dio().post(comment_Url,data:json.encode(map),options: options);

      if(response.statusCode == 200){
        final Map<String,dynamic> map = {'data':response.data};
        return EntityFactory.generateOBJ<CommentEntity>(map);
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}