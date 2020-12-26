import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
// ignore: directives_ordering
import 'dart:async';
import 'package:jiwell_reservation/models/hot_entity.dart';
import '../utils/config.dart';
const String NEW_GOODS_URL = '$SERVER_HOST/goods/searchNew';
class NewGoodsDao{
  static Future<HotEntity> fetch() async{
    try {
      // ignore: always_specify_types
      final Response response = await Dio().get(NEW_GOODS_URL);
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