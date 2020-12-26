import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/msg_entity.dart';
// ignore: directives_ordering
import 'dart:async';
import '../utils/config.dart';

const String SAVE_SEX_URL = '$SERVER_HOST/user/updateGender/';
class SaveSexDao{

  static Future<MsgEntity> fetch(String sex,String token) async{
    try {
      // ignore: always_specify_types
      final Map<String,String> map = {'Authorization':token};
      final Options options = Options(headers:map);
      // ignore: always_specify_types
      final Response response = await Dio().post(SAVE_SEX_URL+sex,
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




