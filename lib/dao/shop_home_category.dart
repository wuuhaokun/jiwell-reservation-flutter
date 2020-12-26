import 'package:dio/dio.dart';
import 'package:jiwell_reservation/models/category_entity.dart';
import 'package:jiwell_reservation/models/entity_factory.dart';
import '../utils/config.dart';

const String CATEGORY_URL = '$JIWELL_SERVER_HOST/item/category/list?pid=75';

class ShopHomeCategoryDao{

  static Future<CategoryEntity> fetch() async{
    final Map<String,dynamic> map = {'data':[{'name':'點餐','id':'0'},{'name':'訂位','id':'1'}]};
    return EntityFactory.generateOBJ<CategoryEntity>(map);

    // try {
    //   // ignore: always_specify_types
    //   final Response response = await Dio().get(CATEGORY_URL);
    //   if(response.statusCode == 200){
    //     // ignore: always_specify_types
    //     final Map<String,dynamic> map = {'data':response.data};
    //     return EntityFactory.generateOBJ<CategoryEntity>(map);
    //   }else{
    //     throw Exception('StatusCode: ${response.statusCode}');
    //   }
    // } catch (e) {
    //   print(e);
    //   return null;
    // }
  }

}