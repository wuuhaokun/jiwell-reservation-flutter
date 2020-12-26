import 'package:dio/dio.dart';
import 'dart:async';
import 'package:jiwell_reservation/utils/config.dart';

class JwfirebaseDao{

  static String jwfirebaseUrl = '$JIWELL_SERVER_HOST/fcm/firebase/token';

  static Future<bool> fetch(int userId,String token) async{
    try {
      Map<String,dynamic> map ={'userId':userId,'token':token};
      final Response response = await Dio().post(jwfirebaseUrl,data: map);
      if(response.statusCode == 200 || response.statusCode == 201){
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




