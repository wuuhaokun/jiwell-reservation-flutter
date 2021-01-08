import 'package:flutter/material.dart';
import 'package:jiwell_reservation/models/cart_goods_query_entity.dart';
import 'package:jiwell_reservation/models/category_entity.dart';
import 'package:jiwell_reservation/models/new/brands_entity.dart';
import 'package:jiwell_reservation/routes/routes.dart';
// ignore: directives_ordering
import 'dart:convert';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jiwell_reservation/utils/image_utils.dart';
/// 輪播組件
// ignore: must_be_immutable
class SwiperDiy extends StatelessWidget{
  final List<BrandsModel> goodsModleDataList;
  final List<CategoryInfoModel> swiperDataList;
  final double height;
  final double width;

  String imgUrl = 'http://linjiashop-mobile-api.microapp.store/file/getImgStream?idFile=';
  // ignore: sort_constructors_first
  SwiperDiy({Key key,this.goodsModleDataList,this.swiperDataList,this.height,this.width}):super(key:key);
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
                if(swiperDataList[index].page.isNotEmpty) {
                  if (swiperDataList[index].page.startsWith('http') ||
                      swiperDataList[index].page.startsWith('https')) {
                    _goWeb(context, swiperDataList[index].page);
                  } else if ('goods' == swiperDataList[index].page) {
                    final Map<String, dynamic> result = jsonDecode(
                        swiperDataList[index].param);
                    if (result.containsKey('id')) {
                      _goDetail(context, result['id'].toString());
                    }
                  }
                }
              },
              //              body: Center(
//                child: CachedNetworkImage(
//                  placeholder: (context, url) => CircularProgressIndicator(),
//                  imageUrl:
//                  'https://picsum.photos/250?image=9',
//                ),
//              ),
              //child: Image.network(
              //  imgUrl+"${swiperDataList[index].idFile}",
              //  fit: BoxFit.cover,
              //),
              child: ImageUtils.getCachedNetworkImage(imgUrl+"${swiperDataList[index].image}",BoxFit.cover,null),
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


    //final String id = goodsModleDataList[i].skuId;
    //final Map<String, String> p = {'id':id};
    //Routes.instance.navigateToParams(context,Routes.PRODUCT_DETAILS,params: p);
    //Routes.instance.navigateToParams(context,Routes.product_items_page,params: p);



    //goodsModleDataList

    // ignore: always_specify_types
    // final Map<String, String> p = {'id':id};
    // Routes.instance.navigateToParams(context,Routes.PRODUCT_DETAILS,params: p);

    //BrandsModel brandsModel = goodsModleDataList[i];
    for(BrandsModel brandsModel in goodsModleDataList){
      if(brandsModel.id.toString() == id){
        final String incategory = brandsModel.incategory;
        final Map<String, String> p = {'name':brandsModel.name,'id':id,'incategory':incategory};
        Routes.instance.navigateToParams(context,Routes.product_items_page,params: p);
        return;
      }
    }

  }

}