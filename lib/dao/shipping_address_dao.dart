import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/shipping_entity.dart';
import 'package:jiwell_reservation/receiver/event_bus.dart';
// ignore: directives_ordering
import 'dart:async';
import '../utils/config.dart';



class ShippingAddressDao{
  static Future<ShippingAddresEntry> fetch(String token) async{
    const String SHIPPING_URL = '$JIWELL_SERVER_HOST/address';
    try {
      final Options options = Options(headers: {'Authorization':'Bearer '+ token});
      final Response response = await Dio().get(SHIPPING_URL,
          options: options);
      if(response.statusCode == 200){
        final Map<String,dynamic>map = {'data':response.data};
        return EntityFactory.generateOBJ<ShippingAddresEntry>(map);
      }
      else{
        eventBus.fire(UserLoggedInEvent('fail'));
        return null;
      }
    } catch (e) {
      print(e);
      if(e.response.statusCode == 404){
        return ShippingAddresEntry();
      }
      return null;
    }
  }
}




