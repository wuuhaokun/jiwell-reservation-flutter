import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/topic_details_entity.dart';
// ignore: directives_ordering
import 'dart:async';
import '../utils/config.dart';
const String TOPIC_DETAIL_URL = '$SERVER_HOST/topic/';


class TopicDetailsDao{

  static Future<TopicDetailsEntity> fetch(String id) async{
    try {
      // ignore: always_specify_types
      final Response response = await Dio().get(TOPIC_DETAIL_URL+id);
      if(response.statusCode == 200){
        return EntityFactory.generateOBJ<TopicDetailsEntity>(response.data);
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}