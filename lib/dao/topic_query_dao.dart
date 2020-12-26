import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/topic_goods_query_entity.dart';
// ignore: directives_ordering
import 'dart:async';
import '../utils/config.dart';

const String TOPIC_URL = '$SERVER_HOST/topic/list';
class TopicQueryDao{

  static Future<TopicGoodsQueryEntity> fetch() async{
    try {
      // ignore: always_specify_types
      final Response response = await Dio().get(TOPIC_URL);
      if(response.statusCode == 200){
        return EntityFactory.generateOBJ<TopicGoodsQueryEntity>(response.data);
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}