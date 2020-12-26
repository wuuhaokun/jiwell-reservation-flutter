import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/details_entity.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
import 'dart:async';
import '../utils/config.dart';

const String FINDING_URL = '$JIWELL_SERVER_HOST/item/goods/sku/';
class DetailsDao{

  static Future<DetailsEntity> fetch(String id) async{
    try {

      // ignore: always_specify_types
      final Response response = await Dio().get(FINDING_URL+id);
      if(response.statusCode == 200){
        // ignore: always_specify_types
        final Map<String,dynamic> map = {'data':response.data};
        return EntityFactory.generateOBJ<DetailsEntity>(map);
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}

//const FINDING_URL = '$SERVER_HOST/goods/';
//class DetailsDao {
//
//  static Future<DetailsEntity> fetch(String id) async {
//    try {
//      Response response = await Dio().get(FINDING_URL + '2');
//      if (response.statusCode == 200) {
//        return EntityFactory.generateOBJ<DetailsEntity>(response.data);
//      } else {
//        throw Exception("StatusCode: ${response.statusCode}");
//      }
//    } catch (e) {
//      print(e);
//      return null;
//    }
//  }
//}
