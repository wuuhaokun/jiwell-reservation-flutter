import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/cart_goods_query_entity.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/order_detail_entity.dart';
import 'package:jiwell_reservation/models/order_entity.dart';
import 'package:jiwell_reservation/receiver/event_bus.dart';
// ignore: directives_ordering
import 'dart:async';

import '../utils/config.dart';

const String OREDER_DETAIL_GET_URL = '$SERVER_HOST/user/order/';

class OrderDetailDao{

  static Future<OrderDetailEntry> fetch(String  orderSn,String token) async{
    try {

      // ignore: always_specify_types
      final Map<String,String> map = {'Authorization':token};
      final Options options = Options(headers:map);
      // ignore: always_specify_types
      final Response response = await Dio().get(OREDER_DETAIL_GET_URL+orderSn,options: options);
      if(response.statusCode == 200){
        return EntityFactory.generateOBJ<OrderDetailEntry>(response.data);
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }

    } catch (e) {
      print(e);
      return null;
    }
  }

}