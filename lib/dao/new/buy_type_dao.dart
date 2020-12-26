import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
import 'package:jiwell_reservation/models/new/buy_type_entity.dart';
import 'package:jiwell_reservation/utils/config.dart';


class BuyTypeDao{

  static Future<BuyTypeEntity> fetch() async{
    const String CATEGORY_URL = '$JIWELL_SERVER_HOST/item/category/buyType';
    try {
      // ignore: always_specify_types
      final RequestOptions options = RequestOptions(/*headers: {'Authorization':token,'content-type':'application/json'},*/connectTimeout: 5000);
      final Response response = await Dio().get(CATEGORY_URL,options: options);
      if(response.statusCode == 200){
        // ignore: always_specify_types
        final Map<String,dynamic> map = {'data':response.data};
        return EntityFactory.generateOBJ<BuyTypeEntity>(map);
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}