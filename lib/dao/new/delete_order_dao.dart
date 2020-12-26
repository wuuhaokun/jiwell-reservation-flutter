
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:jiwell_reservation/utils/config.dart';


class DeleteOrderDao{
  static Future<bool> fetch(String token, String orderId) async{
    const String SAVE_ORDER_URL = '$JIWELL_SERVER_HOST/order/';
    try {
      final String headerToken = 'Bearer '+ token;
      final Options options = Options(headers: {'Authorization':headerToken});
      final Response response = await Dio().delete(SAVE_ORDER_URL + orderId,options: options);
      if(response.statusCode == 200){
        return true;
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}