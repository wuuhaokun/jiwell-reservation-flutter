import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/new/version_update_entity.dart';


class VersionUpdateDao {
  static String url = '';//'$CARPLUS_SERVER_HOST/restv2/app/goSmartUpdate';
  static Future<VersionUpdateEntity> fetch() async {
    try {
      final RequestOptions options = RequestOptions(
        /*headers: {'Authorization':token,'content-type':'application/json'},*/ connectTimeout:
      10000);
      final Map<String, dynamic> params =
      {}; //{'Version':'01.00','Token':token,'MessageType':'RentalStationList','TransactionNumber':uuid,'Tr};
      Dio dio = Dio();
      //沒效，不知為何？
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
      };

      final Response response = await dio.post(url, options: options);
      //print(response);
      if (response.statusCode == 200) {
        return EntityFactory.generateOBJ<VersionUpdateEntity>(response.data);
      } else {
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}



