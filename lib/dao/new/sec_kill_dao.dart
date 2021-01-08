import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/details_entity.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/new/buy_type_entity.dart';
import 'package:jiwell_reservation/models/new/wsku_entity.dart';
import 'package:jiwell_reservation/utils/config.dart';


class SecKillDao{

  static Future<WskuEntity> fetch() async{
    const String SecKill_URL = '$JIWELL_SERVER_HOST/item/goods/seckill/list';
    try {
      // ignore: always_specify_types
      final RequestOptions options = RequestOptions(/*headers: {'Authorization':token,'content-type':'application/json'},*/connectTimeout: 5000);
      final Response response = await Dio().get(SecKill_URL,options: options);
      if(response.statusCode == 200){
        // ignore: always_specify_types
        final Map<String,dynamic> map = {'data':response.data};
        return EntityFactory.generateOBJ<WskuEntity>(map);
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}