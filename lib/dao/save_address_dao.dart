import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/msg_entity.dart';
import 'package:jiwell_reservation/models/shipping_entity.dart';
import 'package:jiwell_reservation/receiver/event_bus.dart';
// ignore: directives_ordering
import 'dart:async';
import '../utils/config.dart';

// const String SAVE_ADDRESS_URL = '$SERVER_HOST/user/address/save';
// class SaveDao{
//
//   static Future<MsgEntity> fetch(Map<String, dynamic> param,String token) async{
//     try {
//       final Options options = Options(headers: {'Authorization':token,'content-type':'application/json'});
//
//       // ignore: always_specify_types
//       final Response response = await Dio().post(SAVE_ADDRESS_URL,
//           data:json.encode(param),
//           options: options);
//       if(response.statusCode == 200){
//         return EntityFactory.generateOBJ<MsgEntity>(response.data);
//       }else{
//         throw Exception('StatusCode: ${response.statusCode}');
//       }
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }
//
// }
const String ADDRESS_URL = '$JIWELL_SERVER_HOST/address';
class SaveAddressDao{
  static Future<bool> fetch(Map<String, dynamic> param,String token) async{
    try {
      final Options options = Options(headers: {'Authorization':'Bearer '+ token});
      final Response response = await Dio().post(ADDRESS_URL,data:json.encode(param),
          options: options);
      if(response.statusCode == 201){
        return true;
      }else{
        //eventBus.fire(UserLoggedInEvent('fail'));
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}

class EditAddressDao{
  static Future<bool> fetch(Map<String, dynamic> param,String token) async{
    try {
      final Options options = Options(headers: {'Authorization':'Bearer '+ token});
      final Response response = await Dio().put(ADDRESS_URL,data:json.encode(param),
          options: options);
      if(response.statusCode == 204){
        return true;
      }else{
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}


