import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/order_entity.dart';
import 'package:jiwell_reservation/receiver/event_bus.dart';
// ignore: directives_ordering
import 'dart:async';
import '../utils/config.dart';

const String OREDER_GET_URL = '$JIWELL_SERVER_HOST/order/list?';

class OrderQueryDao{

  static Future<OrderEntity> fetch(int status,int page,String token) async{
    try {
      final String params = 'page=1'+ '&rows=100' + '&status=' + status.toString();
      final String headerToken = 'Bearer '+ token;
      final Options options = Options(headers: {'Authorization':headerToken});
      final Response response = await Dio().get(OREDER_GET_URL + params,options: options);
      if(response.statusCode == 200){
        final Map<String,dynamic>map = {'data':response.data};
        return EntityFactory.generateOBJ<OrderEntity>(map/*response.data*/);
      }
      else{
        eventBus.fire(UserLoggedInEvent('fail'));
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}