import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/msg_entity.dart';

// ignore: directives_ordering
import 'dart:async';
import '../utils/config.dart';

const String LIKE_URL = '$SERVER_HOST/user/favorite/add/';
class AddLikeDao{

  static Future<MsgEntity> fetch(String token,String id) async {
    try {
      // ignore: always_specify_types
      final Options options = Options(headers: {'Authorization': token});
      // ignore: always_specify_types
      final Response response = await Dio().post(LIKE_URL + id, options: options);
      if (response.statusCode == 200) {
        return EntityFactory.generateOBJ<MsgEntity>(response.data);
      } else {
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}