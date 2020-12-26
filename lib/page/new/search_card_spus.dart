import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiwell_reservation/dao/new/spu_dao.dart';
import 'package:jiwell_reservation/models/new/spu_entity.dart';
import 'package:jiwell_reservation/models/new/spus_entity.dart';
import 'package:jiwell_reservation/routes/routes.dart';
import 'package:jiwell_reservation/view/custom_view.dart';

import 'card_spus.dart';

// ignore: must_be_immutable
class SearchCardSpus  extends CardSpus {
  SpusModel _spusModel;
  @override
  final List<SpusModel> goodsModleDataList;
  @override
  SearchCardSpus({Key key, this.goodsModleDataList}) :super(key: key);

  @override
  void initState() {
  }

  @override
  void onItemClick(BuildContext context,int i) async {
    EasyLoading.show(status: '載入中，請稍後...');
    SpusModel spusModel = goodsModleDataList[i];
    final SpuEntity entity = await SpuDao.fetch(spusModel.id);
    if(entity?.spusModel != null){
      String spuJsonString = jsonEncode(entity?.spusModel);
      final Map<String, dynamic> p = {'spusModelJson':spuJsonString};
      Routes.instance.navigateToParams(context,Routes.Product_Spec_page,params: p);
      EasyLoading.dismiss();
    }else{
      EasyLoading.dismiss();
    }
  }
}