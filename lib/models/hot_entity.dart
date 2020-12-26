import 'package:jiwell_reservation/models/goods_entity.dart';
import 'dart:convert';


class HotEntity {
  List<GoodsModel> goods;
  HotEntity({this.goods});
  HotEntity.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      goods = new List<GoodsModel>();
//			print(goods.runtimeType);
      List<Map> dataList= (json['data'] as List).cast();
      dataList.forEach((v) {
        goods.add(new GoodsModel.fromJson(v));
//				print(goods.length);
      }
      );
    }
  }
}

class SearchEntity {
  List<GoodsModel> goods;
  SearchEntity({this.goods});
  SearchEntity.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      goods = new List<GoodsModel>();
      List<Map> dataList= (json['data']['items'] as List).cast();
      dataList.forEach((v) {
          String skus = v['skus'];
          List<dynamic> skusList = jsonDecode(skus);
          skusList.forEach((w) {
            Map<String, dynamic> skus = w;
            String skuId = skus['id'].toString();
            skus.addAll({'skuId': skuId});
            skus.addAll(v);
            goods.add(GoodsModel.fromJson(skus));
          });
      }
      );
    }
  }
}