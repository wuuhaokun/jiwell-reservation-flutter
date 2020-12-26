
import 'dart:convert';
import 'package:jiwell_reservation/generated/i18n.dart';
import 'package:jiwell_reservation/models/goods_entity.dart';
import 'package:jiwell_reservation/models/new/spus_entity.dart';

class SpuEntity {
  SpusModel spusModel;
  SpuEntity({this.spusModel});
  SpuEntity.fromJson(Map<String, dynamic> json) {
    if (json != null && json['data'] != null) {
        spusModel = new SpusModel.fromJson(json['data']);
    }
  }
}
