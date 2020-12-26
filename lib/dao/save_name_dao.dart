import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/msg_entity.dart';
// ignore: directives_ordering
import 'dart:async';
import '../utils/config.dart';
const String SAVE_NAME_URL = '$SERVER_HOST/user/updateUserName/';

class SaveNameDao{

  static Future<MsgEntity> fetch(String name,String token) async{
    try {
      final Map<String,String> map={'Authorization':token};
      final Options options = Options(headers:map);
      // ignore: always_specify_types
      final Response response = await Dio().post(SAVE_NAME_URL+name,
          options: options);
      if(response.statusCode == 200){
        return EntityFactory.generateOBJ<MsgEntity>(response.data);
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}




