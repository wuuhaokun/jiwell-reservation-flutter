import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/address_entity.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/shipping_entity.dart';
import 'package:jiwell_reservation/receiver/event_bus.dart';
// ignore: directives_ordering
import 'dart:async';
import '../utils/config.dart';
const SHIPPING_EDIT_URL = '$JIWELL_SERVER_HOST/address';

class ShippingEditAddressDao{
  static Future<AddressEditEntity> fetch(String token,String id) async{
    if(int.parse(id) <= 0) {
      return null;
    }
    try {
      final String headerToken = 'Bearer '+ token;
      // ignore: always_specify_types
      final Options options = Options(headers: {'Authorization':headerToken});
      // ignore: always_specify_types
      final Response response = await Dio().get(SHIPPING_EDIT_URL,
          options: options);
      if(response.statusCode == 200){
        // ignore: avoid_as
        final int index = int.parse(id);
        final Map<String,dynamic>map = {'data':response.data[index-1]};
        return EntityFactory.generateOBJ<AddressEditEntity>(map);
      }else{
        eventBus.fire(UserLoggedInEvent('fail'));
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}




