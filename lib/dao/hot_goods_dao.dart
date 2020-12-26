import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
// ignore: directives_ordering
import 'dart:async';
import 'package:jiwell_reservation/models/hot_entity.dart';
import '../utils/config.dart';

const String HOT_URL = '$SERVER_HOST/goods/searchHot';
class HotGoodsDao{
  static Future<HotEntity> fetch() async{
    try {
      // ignore: always_specify_types
      final Response response = await Dio().get(HOT_URL);
      if(response.statusCode == 200){
        return EntityFactory.generateOBJ<HotEntity>(response.data);
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}