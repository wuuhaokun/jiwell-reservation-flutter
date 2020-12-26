
import 'package:jiwell_reservation/dao/classify_dao.dart';
import 'package:jiwell_reservation/models/address_entity.dart';
import 'package:jiwell_reservation/models/cart_entity.dart';
import 'package:jiwell_reservation/models/details_entity.dart';
import 'package:jiwell_reservation/models/login_entity.dart';
import 'package:jiwell_reservation/models/msg_entity.dart';
import 'package:jiwell_reservation/models/msg_like_entity.dart';
import 'package:jiwell_reservation/models/order_detail_entity.dart';
import 'package:jiwell_reservation/models/order_entity.dart';
import 'package:jiwell_reservation/models/shipping_entity.dart';
import 'package:jiwell_reservation/models/topic_details_entity.dart';
import 'package:jiwell_reservation/models/topic_goods_query_entity.dart';
import 'package:jiwell_reservation/models/user_entity.dart';


import 'cart_goods_query_entity.dart';
import 'category_entity.dart';
import 'file_upload_entity.dart';
import 'goods_entity.dart';
import 'hot_entity.dart';
import 'new/brands_entity.dart';
import 'new/buy_type_entity.dart';
import 'new/cart_goods_entity.dart';
import 'new/comment_entity.dart';
import 'new/coupon_entity.dart';
import 'new/specifications_entity.dart';
import 'new/spu_entity.dart';
import 'new/spu_search_entity.dart';
import 'new/spus_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(dynamic json) {
    if (1 == 0) {
      return null;
    }  else if (T.toString() == "GoodsEntity"){
      return GoodsEntity.fromJson(json) as T;
    }else if (T.toString() == "GoodsEntity1") {
      return GoodsEntity1.fromJson(json) as T;
    }
    else if (T.toString() == "CategoryEntity"){
      return CategoryEntity.fromJson(json) as T;
    }else if (T.toString() == "DetailsEntity"){
      return DetailsEntity.fromJson(json) as T;
    }else if (T.toString() == "LoginEntity"){
      return LoginEntity.fromJson(json) as T;
    }else if (T.toString() == "HotEntity"){
      return HotEntity.fromJson(json) as T;
    }else if (T.toString() == "SearchEntity"){
      return SearchEntity.fromJson(json) as T;
    }else if (T.toString() == "CartEntity"){
      return CartEntity.fromJson(json) as T;
    }else if (T.toString() == "CartGoodsQueryEntity"){
      return CartGoodsQueryEntity.fromJson(json) as T;
    }else if (T.toString() == "MsgEntity"){
      return MsgEntity.fromJson(json) as T;
    }else if (T.toString() == "OrderEntity"){
      return OrderEntity.fromJson(json) as T;
    }else if (T.toString() == "OrderDetailEntry"){
      return OrderDetailEntry.fromJson(json) as T;
    }else if (T.toString() == "ShippingAddresEntry"){
      return ShippingAddresEntry.fromJson(json) as T;
    }else if (T.toString() == "AddressEditEntity"){
      return AddressEditEntity.fromJson(json) as T;
    }else if (T.toString() == "UserEntity"){
      return UserEntity.fromJson(json) as T;
    }else if (T.toString() == "TopicGoodsQueryEntity"){
      return TopicGoodsQueryEntity.fromJson(json) as T;
    }else if (T.toString() == "TopicDetailsEntity"){
      return TopicDetailsEntity.fromJson(json) as T;
    }else if (T.toString() == "FileEntity"){
      return FileEntity.fromJson(json) as T;
    }else if (T.toString() == "MsgLikeEntity"){
      return MsgLikeEntity.fromJson(json) as T;
    }
    else if(T.toString() == "Classify"){
      return Classify.fromJson(json) as T;
    }
    //新加入的
    else if(T.toString() == 'BuyTypeEntity'){
      return BuyTypeEntity.fromJson(json) as T;
    }
    else if(T.toString() == 'BrandsEntity'){
      return BrandsEntity.fromJson(json) as T;
    }
    else if(T.toString() == 'SpusEntity'){
      return SpusEntity.fromJson(json) as T;
    }
    else if(T.toString() == 'SpecificationsEntity'){
    return SpecificationsEntity.fromJson(json) as T;
    }
    else if(T.toString() == 'CartGoodsEntity'){
      return CartGoodsEntity.fromJson(json) as T;
    }
    else if(T.toString() == 'SpuSearchEntity'){
      return SpuSearchEntity.fromJson(json) as T;
    }
    else if(T.toString() == 'SpuEntity'){
      return SpuEntity.fromJson(json) as T;
    }
    else if(T.toString() == 'CouponEntity'){
      return CouponEntity.fromJson(json) as T;
    }
    else if(T.toString() == 'CouponHistoryDetailEntity'){
      return CouponHistoryDetailEntity.fromJson(json) as T;
    }
    else if(T.toString() == 'CommentEntity'){
      return CommentEntity.fromJson(json) as T;
    }

    else {
      return null;
    }
  }
}