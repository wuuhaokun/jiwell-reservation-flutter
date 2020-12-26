import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
// ignore: directives_ordering
import 'dart:async';
import 'package:jiwell_reservation/models/goods_entity.dart';
import 'package:jiwell_reservation/models/msg_entity.dart';
import '../utils/config.dart';

/// 发送验证码
class SendSmsDao{

  static Future<bool> fetch(String mobile) async{
    try {
      const SEND_URL = '$JIWELL_SERVER_HOST/user/register/code';
      final Map<String,dynamic> map = {'phone':mobile};
      final Response response = await Dio().post(SEND_URL,queryParameters: map);
      if(response.statusCode == 200 || response.statusCode == 201){
        //return EntityFactory.generateOBJ<MsgEntity>(response.data);
        return true;
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

}