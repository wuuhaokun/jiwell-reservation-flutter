import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/new/comment_entity.dart';
import 'package:jiwell_reservation/utils/config.dart';


class CommentDao{

  static Future<CommentEntity> listFetch(String token, String useStatus) async{
    const String FAVORITE_URL = '$JIWELL_SERVER_HOST/favorite/coupon/list?useStatus=';
    try {
      final String headerToken = 'Bearer '+ token;
      final RequestOptions options = RequestOptions(headers: {'Authorization':headerToken,'content-type':'application/json'},connectTimeout: 5000);
      final Response response = await Dio().get(FAVORITE_URL+useStatus,options: options);
      if(response.statusCode == 200){
        final Map<String,dynamic> map = {'items':response.data};
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