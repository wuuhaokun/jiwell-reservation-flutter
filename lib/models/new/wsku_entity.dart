
import 'dart:convert';
import 'package:jiwell_reservation/generated/i18n.dart';
import 'package:jiwell_reservation/models/goods_entity.dart';
import 'package:jiwell_reservation/models/new/spus_entity.dart';

class WskuEntity {
  List<WskuModel> wskuModelList = [];
  WskuEntity({this.wskuModelList});
  WskuEntity.fromJson(Map<String, dynamic> json) {
    if (json != null && json['data'] != null) {
      (json['data'] as List).forEach((v) {
        wskuModelList.add(WskuModel.fromJson(v));
      });
    }
  }
}
