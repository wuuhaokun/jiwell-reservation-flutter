//import 'package:dio/dio.dart';
//import 'package:jiwell_reservation/models/entity_factory.dart';
//import 'dart:async';
//import 'package:jiwell_reservation/models/goods_entity.dart';
//import '../utils/config.dart';
//const FINDING_URL = '$SERVER_HOST/goods/queryGoods';
//class FindingsDao{
//
//  static Future<GoodsEntity> fetch(String id) async{
//    try {
//      Map<String,dynamic> map={"idCategory":id};
//      Response response = await Dio().get(FINDING_URL,queryParameters: map);
//      if(response.statusCode == 200){
//        return EntityFactory.generateOBJ<GoodsEntity>(response.data);
//      }else{
//        throw Exception("StatusCode: ${response.statusCode}");
//      }
//    } catch (e) {
//      print(e);
//      return null;
//    }
//  }
//
//}

import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/goods_entity.dart';
import 'package:jiwell_reservation/models/new/brands_entity.dart';
import 'package:jiwell_reservation/models/new/spus_entity.dart';
import '../utils/config.dart';



class FindingsDao{

  static Future<GoodsEntity> fetch(String ids) async{
    String FINDING_URL = '$JIWELL_SERVER_HOST/item/goods/spu/page';
    try {
      // ignore: always_specify_types
      final Map<String,dynamic> map = {'page':'1','rows':'10','sortBy':'false','desc':'false','key':'','saleable':'true','cid3':ids};
      // ignore: always_specify_types
      final Response response = await Dio().get(FINDING_URL,queryParameters: map);
      if(response.statusCode == 200){
        return EntityFactory.generateOBJ<GoodsEntity>(response.data);
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}

class FindingsSpuDao{

  static Future<SpusEntity> fetch(String ids) async{
    const String FINDING_URL = '$JIWELL_SERVER_HOST/item/goods/spu/page';
    try {
      // ignore: always_specify_types
      final Map<String,dynamic> map = {'page':'1','rows':'50','sortBy':'false','desc':'false','key':'','saleable':'true','cid3':-1,'brandId':int.parse(ids)};
      // ignore: always_specify_types
      final Response response = await Dio().get(FINDING_URL,queryParameters: map);
      if(response.statusCode == 200){
        return EntityFactory.generateOBJ<SpusEntity>(response.data);
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // static Future<GoodsEntity1> fetch(String ids) async{
  //   String FINDING_URL = '$JIWELL_SERVER_HOST/item/goods/spu/page';
  //   try {
  //     // ignore: always_specify_types
  //     final Map<String,dynamic> map = {'page':'1','rows':'50','sortBy':'false','desc':'false','key':'','saleable':'true','cid3':-1,'brandId':int.parse(ids)};
  //     // ignore: always_specify_types
  //     final Response response = await Dio().get(FINDING_URL,queryParameters: map);
  //     if(response.statusCode == 200){
  //       return EntityFactory.generateOBJ<GoodsEntity1>(response.data);
  //     }else{
  //       throw Exception('StatusCode: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

}


class BrandFindingsDao{

  static Future<BrandsEntity> fetch(String ids) async{
    String FINDING_URL = '$JIWELL_SERVER_HOST/item/brand/list/${ids}';
    try {
      final Response response = await Dio().get(FINDING_URL);
      if(response.statusCode == 200){
        final Map<String,dynamic> map = {'data':response.data};
        return EntityFactory.generateOBJ<BrandsEntity>(map);
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}