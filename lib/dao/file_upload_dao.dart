import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/file_upload_entity.dart';
// ignore: directives_ordering
import 'dart:async';
import '../utils/config.dart';

const String FILE_UPLOAD_URL = '$SERVER_HOST/file/upload/base64';

class FileUploadDao{

  static Future<FileEntity> fetch(Map<String, dynamic> param,String token) async{
    try {
      // ignore: always_specify_types
      final Options options = Options(headers: {'Authorization':token,'content-type':'application/json'});

      // ignore: always_specify_types
      final Response response = await Dio().post(FILE_UPLOAD_URL,
          data:json.encode(param),
          options: options);
      if(response.statusCode == 200){
        return EntityFactory.generateOBJ<FileEntity>(response.data);
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}




