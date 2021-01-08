import 'package:flutter/material.dart';
import 'package:jiwell_reservation/models/cart_goods_query_entity.dart';
import 'package:jiwell_reservation/models/category_entity.dart';
import 'package:jiwell_reservation/models/details_entity.dart';
import 'package:jiwell_reservation/models/new/brands_entity.dart';
import 'package:jiwell_reservation/models/new/spus_entity.dart';
import 'package:jiwell_reservation/routes/routes.dart';
// ignore: directives_ordering
import 'dart:convert';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jiwell_reservation/utils/image_utils.dart';
/// 輪播組件
// ignore: must_be_immutable
class SpuSwiperDiy extends StatelessWidget{
  final List<WskuModel> swiperDataList;
  final double height;
  final double width;

  String imgUrl = 'http://linjiashop-mobile-api.microapp.store/file/getImgStream?idFile=';
  // ignore: sort_constructors_first
  SpuSwiperDiy({Key key,this.swiperDataList,this.height,this.width}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: InkWell(
              onTap: (){
                final int id = swiperDataList[0].skuId;
                final Map<String, String> p = {'id':id.toString()};
                Routes.instance.navigateToParams(context,Routes.PRODUCT_DETAILS,params: p);
              },
              child: ImageUtils.getCachedNetworkImage(imgUrl+"${swiperDataList[index].images}",BoxFit.cover,null),
            )
          );
        },
        itemCount: swiperDataList.length,
        pagination: const SwiperPagination(margin: EdgeInsets.all(1.0)),
        autoplay: true,
      ),
    );

  }
  void _goWeb(BuildContext context,String url){
    // ignore: always_specify_types
    final Map<String, String> p = {'url':url};
    Routes.instance.navigateToParams(context,Routes.web_page,params: p);
  }
  void _goDetail(BuildContext context,String id){
    // for(BrandsModel brandsModel in goodsModleDataList){
    //   if(brandsModel.id.toString() == id){
    //     final String incategory = brandsModel.incategory;
    //     final Map<String, String> p = {'name':brandsModel.name,'id':id,'incategory':incategory};
    //     Routes.instance.navigateToParams(context,Routes.product_items_page,params: p);
    //     return;
    //   }
    // }

  }

}