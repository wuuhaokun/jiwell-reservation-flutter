
import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/new/spu_entity.dart';
import 'dart:async';
import '../../utils/config.dart';

class SpuDao{
  static Future<SpuEntity> fetch(int spuId) async{
    const String SEAECH_URL = '$JIWELL_SERVER_HOST/item/goods/spu/';
    try {
      final Response response = await Dio().get(SEAECH_URL+spuId.toString());
      if(response.statusCode == 200){
        final Map<String,dynamic>dataMap = {'data':response.data};
        return EntityFactory.generateOBJ<SpuEntity>(dataMap);
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}