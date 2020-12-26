import 'package:jiwell_reservation/models/goods_entity.dart';
import 'dart:convert';

import 'package:jiwell_reservation/models/new/spus_entity.dart';


class SpuSearchEntity {
  List<SpusModel> goods;
  SpuSearchEntity({this.goods});
  SpuSearchEntity.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      goods = new List<SpusModel>();
      List<Map> dataList= (json['data']['items'] as List).cast();
      dataList.forEach((v) {
        goods.add(SpusModel.fromJson(v));
      });
    }
  }
}