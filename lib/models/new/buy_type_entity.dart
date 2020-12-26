import 'package:jiwell_reservation/models/goods_entity.dart';
import 'dart:convert';

import '../category_entity.dart';

class BuyTypeEntity {
  List<BuyTypeModel> buyTypeModelList;
  BuyTypeEntity({this.buyTypeModelList});
  BuyTypeEntity.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      buyTypeModelList = new List<BuyTypeModel>();
      List<Map> dataList= (json['data'] as List).cast();
      dataList.forEach((v) {
        buyTypeModelList.add(new BuyTypeModel.fromJson(v));
      }
      );
    }
  }
}

// class BuyTypeModel {
//   int id;
//   String name;
//   List<CategoryInfoModel> categoryInfoModels;
//   BuyTypeModel({this.id,this.name,this.categoryInfoModels});
//   BuyTypeModel.fromJson(Map<String, dynamic> data) {
//     //final Map<String,dynamic> bannerList = {'bannerList':[{'createTime':'2019-03-09 16:29:03','id':'1','idFile':'75b1e658-161e-4b12-83b0-abd2c1bead39.jpg','modifyBy':'','page':'goods','param':'{\"id\":2}','title':'红米Rote8,打开外部链接','type':'index','url':''}]};
//     // final List list = bannerList['bannerList'] as List;
//     // final List<CategoryInfoModel> categoryInfoList = list.map((i) => CategoryInfoModel.fromJson(i)).toList();
//     ///////////////
//
//     var list = parsedJson['bannerList'] as List;
//
//     List<CategoryInfoModel> categoryInfoList =
//     list.map((i) => CategoryInfoModel.fromJson(i)).toList();
//     //////////////
//
//
//
//
//     id = (data['id']??-1);
//     name = (data['name']??-1);
//     categoryInfoModels = categoryInfoList;
//   }
// }

class BuyTypeModel {
  int id;
  String name;
  List<CategoryInfoModel> categoryInfoModels;
  BuyTypeModel({this.id,this.name,this.categoryInfoModels});
  BuyTypeModel.fromJson(Map<String, dynamic> data) {

    var list = data['bannerList'] as List;
    List<CategoryInfoModel> categoryInfoList =
    list.map((i) => CategoryInfoModel.fromJson(i)).toList();

    id = (data['id']??-1);
    name = (data['name']??-1);
    categoryInfoModels = categoryInfoList;
  }
}