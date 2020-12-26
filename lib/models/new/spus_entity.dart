
import 'dart:convert';
import 'package:jiwell_reservation/generated/i18n.dart';
import 'package:jiwell_reservation/models/goods_entity.dart';
// class GoodsEntity1 extends GoodsEntity {
//   List<SubGoodsEntity> items = <SubGoodsEntity>[];
//
// // ignore: always_specify_types
//   GoodsEntity1({this.items});
//
//   GoodsEntity1.fromJson(Map<String, dynamic> json) {
//     if (json['items'] != null) {
//
//       SubGoodsEntity subGoodsEntity = SubGoodsEntity();
//       final List<GoodsModel> itemGoods = <GoodsModel>[];
//       List<Map> dataList= (json['items'] as List).cast();
//       GoodsModel itemMode = GoodsModel();
//
//       dataList.forEach((v) {
//         itemMode = GoodsModel.fromJson(v);
//         List<Map> skusList= (v['skus'] as List).cast();
//         skusList.forEach((w) {
//           print(w);
//           Map<String, dynamic> data = w;
//           data.addAll({'skuId':data['id']});
//           data.addAll(v);
//           itemGoods.add(GoodsModel.fromJson(data));
//         });
//
//         subGoodsEntity.item = itemMode;
//         subGoodsEntity.goods = itemGoods;
//         items.add(subGoodsEntity);
//
//       });
//     }
//   }
// }·


class SpusEntity {
  List<SpusModel> spusModelList;
  SpusEntity({this.spusModelList});
  SpusEntity.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      spusModelList = <SpusModel>[];
      List<Map> dataList= (json['items'] as List).cast();
      dataList.forEach((v) {
        spusModelList.add(new SpusModel.fromJson(v));
      }
      );
    }
  }
}

class IncategoryEntity {
  List<IncategoryModel> IncategoryList = [];
  IncategoryEntity({this.IncategoryList});
}

class IncategoryModel {
  String incategoryName;
  List<SpusModel> spusModellList = [];
  IncategoryModel({this.incategoryName,this.spusModellList});
  // IncategoryModel.fromJson(Map<String, dynamic> json) {
  //   //incategoryName = (json['incategoryName']??-1);
  //   //spusModellList = new List<List<SpusModel>>();
  //   //List<Map> dataList= (json['data'] as List).cast();
  //   //dataList.forEach((v) {
  //   //  spusModellList.add(new SpusModel.fromJson(v));
  //   //});
  // }
}

class SpusModel {
  int id;
  int brandId;
  int cid1;
  int cid2;
  int cid3;
  String title;
  String subTitle;
  bool saleable;
  bool valid;
  String createTime;
  String lastUpdateTime;
  int internalCategoryId;
  String cname;
  String bname;
  String images;
  SpuDetailModel spuDetailModel;
  List<WskuModel>skuModelLists;
  SpusModel({this.id,this.brandId,this.cid1,this.cid2,this.cid3,this.title,this.subTitle,
  this.saleable,this.valid,this.createTime,this.lastUpdateTime,this.internalCategoryId,
  this.cname,this.bname,this.images,this.spuDetailModel,this.skuModelLists});
  SpusModel.fromJson(Map<String, dynamic> data) {
    id = (data['id']??-1);
    brandId = (data['brandId']??-1);
    cid1 = (data['cid1']??-1);
    cid2 = (data['cid2']??-1);
    cid3 = (data['cid3']??-1);
    title = (data['title']??'');
    subTitle = (data['subTitle']??'');
    saleable = (data['saleable']??false);
    valid = (data['valid']??false);
    // createTime = (data['createTime']??'');
    // lastUpdateTime = (data['lastUpdateTime']??'');
    internalCategoryId = (data['internalCategoryId']??-1);
    cname = (data['cname']??'');
    bname = (data['bname']??'');
    images = (data['image']??'');
    if(data['spuDetail']!= null) {
      spuDetailModel = SpuDetailModel.fromJson(data['spuDetail']);
    }
    if (data['skus'] != null) {
      var skuModelList = new List<WskuModel>();
      List<Map> lists = (data['skus'] as List).cast();
      lists.forEach((v) {
        skuModelList.add(new WskuModel.fromJson(v));
      }
      );
      skuModelLists = skuModelList;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = (id ?? -1);
    data['brandId'] = (brandId ?? -1);
    data['cid1'] = (cid1 ?? -1);
    data['cid2'] = (cid2 ?? -1);
    data['cid3'] = (cid3 ?? -1);
    data['title'] = (title ?? '');
    data['subTitle'] = (subTitle?? '');
    data['saleable'] = (saleable??false);
    data['valid'] = (valid??false);
    data['createTime'] = (createTime??'');
    data['lastUpdateTime'] = (lastUpdateTime??'');
    data['internalCategoryId'] = (internalCategoryId??-1);
    data['cname'] = (cname??'');
    data['bname'] = (bname??'');
    data['image'] = (images??'');
    data['spuDetail'] = spuDetailModel.toJson();
    data['skus'] = skuModelLists.map((WskuModel) => WskuModel.toJson()).toList();
    return data;
  }

}

class SpuDetailModel {
  int spuId;
  String description;
  String specTemplate;
  String specifications;
  String packingList;
  String afterService;

  SpuDetailModel({this.spuId,this.description,this.specTemplate,this.specifications,this.packingList,this.afterService});
  SpuDetailModel.fromJson(Map<String, dynamic> data) {
    spuId = (data['spuId']??-1);
    description = (data['description']??'');
    specTemplate = (data['specTemplate']??'');
    specifications = (data['specifications']??'');
    packingList = (data['packingList']??'');
    afterService = (data['afterService']??'');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['spuIdd'] = (spuId ?? -1);
    data['description'] = (description ?? '');
    data['specTemplate'] = (specTemplate?? '');
    data['specifications'] = (specifications??'');
    data['packingList'] = (packingList??'');
    data['afterService'] = (afterService??'');
    return data;
  }
}

class WskuModel {
  int id;
  int spuId;
  String title;
  String images;
  int price;
  String ownSpec;
  String description;
  String indexes;
  bool enable;
  String createTime;
  String lastUpdateTime;
  int stock;

  WskuModel({this.id,this.spuId,this.title,this.images,this.price,
    this.ownSpec,this.description,this.indexes,this.enable,
    this.createTime,this.lastUpdateTime,this.stock,
  });
  WskuModel.fromJson(Map<String, dynamic> data) {
    id = (data['id']??-1);
    spuId = (data['spuId']??-1);
    title = (data['title']??'');
    images = (data['images']??'');
    price = (data['price']??0);
    ownSpec = (data['ownSpec']??'');
    description = (data['description']??'');
    indexes = (data['indexes']??'');
    enable = (data['enable']??false);
    //createTime = (data['createTime']??'');
    //lastUpdateTime = (data['lastUpdateTime']??'');
    stock = (data['stock']??0);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = (id??-1);
      data['spuId'] = (spuId??-1);
      data['title'] = (title??'');
      data['images'] = (images??'');
      data['price'] = (price??0);
      data['ownSpec'] = (ownSpec??'');
      data['description'] = (description??'');
      data['indexes'] = (indexes??'');
      data['enable'] = (enable??false);
      data['createTime'] = (createTime??'');
      data['lastUpdateTime'] = (lastUpdateTime??'');
      data['stock'] = (stock??0);
    return data;

  }
}

//

// {
// "id": 106,
// "spuId": 1,
// "title": "茉莉綠茶-中杯(加椰果)",
// "images": "http://image.ji-well.com/images/9/15/1524297313793.jpg ",
// "price": 40,
// "ownSpec": "{\"大小選擇\":\"中\",\"加料選擇\":\"椰果\"}",
// "indexes": "1_10",
// "enable": true,
// "createTime": "2020-09-11T20:55:14.000+0000",
// "lastUpdateTime": "2020-09-11T20:55:14.000+0000",
// "stock": 9999
// }


// @Id
// /**
//  * 对应的SPU的id
//  */
// private Long spuId;
// /**
//  * 商品描述
//  */
// private String description;
// /**
//  * 商品特殊规格的名称及可选值模板
//  */
// private String specTemplate;
// /**
//  * 商品的全局规格属性
//  */
// private String specifications;
// /**
//  * 包装清单
//  */
// private String packingList;
// /**
//  * 售后服务
//  */
// private String afterService;

// class GoodsEntity1 extends GoodsEntity {
//   List<SubGoodsEntity> items = <SubGoodsEntity>[];
//   GoodsEntity1({this.items});
//   GoodsEntity1.fromJson(Map<String, dynamic> json) {
//     if (json['items'] != null) {
//
//       SubGoodsEntity subGoodsEntity = SubGoodsEntity();
//       final List<GoodsModel> itemGoods = <GoodsModel>[];
//       List<Map> dataList= (json['items'] as List).cast();
//       GoodsModel itemMode = GoodsModel();
//
//       dataList.forEach((v) {
//         itemMode = GoodsModel.fromJson(v);
//         //List<Map> skusList= (v['skus'] as List).cast();
//         //skusList.forEach((w) {
//         //	print(w);
//         //	Map<String, dynamic> data = w;
//         //	data.addAll({'skuId':data['id']});
//         //	data.addAll(v);
//         //	itemGoods.add(GoodsModel.fromJson(data));
//         //});
//
//         subGoodsEntity.item = itemMode;
//         //subGoodsEntity.goods = itemGoods;
//         items.add(subGoodsEntity);
//
//       });
//     }
//   }
// }