import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiwell_reservation/common.dart';
import 'package:jiwell_reservation/models/new/brands_entity.dart';
import 'package:jiwell_reservation/routes/routes.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/view/custom_view.dart';
// ignore: must_be_immutable
class SubListViewBrands extends StatelessWidget {
  final List<BrandsModel> goodsModleDataList;
  String imgUrl = 'http://linjiashop-mobile-api.microapp.store/file/getImgStream?idFile=';
  // ignore: sort_constructors_first
  SubListViewBrands({Key key, this.goodsModleDataList}) :super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: AppSize.height(290),
        color:Colors.white,
        margin: const EdgeInsets.only(top: 5.0),
        padding:const EdgeInsets.all(3.0),
        child:  _buildWidget(context)
    );
  }
  Widget _buildWidget(BuildContext context) {
    // ignore: always_specify_types
    final List<Widget> mGoodsCard = [];
    Widget content;
    for (int i = 0; i < goodsModleDataList.length; i++) {
      //final double priceDouble = goodsModleDataList[i].price/100;
      mGoodsCard.add(InkWell(
          onTap: () {
            onItemClick(context,i);
          },
        // child:Container(
        //   width: AppSize.height(680) ,
        //   color: coo,
        // ),
          child: BrandsListViewThemeCard(
            title: goodsModleDataList[i].name,
            //price:'¥'+priceDouble.toStringAsFixed(2) ,
            imgUrl:imgUrl+goodsModleDataList[i].image,
            descript: goodsModleDataList[i].title,
            //number: 'x'+goodsModleDataList[i].stock.toString(),
          )
      )
      );
    }
    content = ListView(
      scrollDirection: Axis.horizontal,
      children: mGoodsCard,
    );
    return content;
  }

  void onItemClick(BuildContext context,int i){
    BrandsModel brandsModel = goodsModleDataList[i];
    final String id = brandsModel.id.toString();
    final String incategory = brandsModel.incategory;
    final Map<String, String> p = {'name':brandsModel.name,'id':id,'incategory':incategory};
    //Routes.instance.navigateToParams(context,Routes.PRODUCT_DETAILS,params: p);
    Routes.instance.navigateToParams(context,Routes.product_items_page,params: p);
  }
}