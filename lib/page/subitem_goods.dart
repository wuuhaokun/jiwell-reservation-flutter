import 'package:flutter/material.dart';
import 'package:jiwell_reservation/models/goods_entity.dart';
import 'package:jiwell_reservation/routes/routes.dart';
import 'package:jiwell_reservation/view/custom_view.dart';
// ignore: must_be_immutable
class SubItemGoods extends StatelessWidget {
  final List<GoodsModel> goodsModleDataList;
  String imgUrl = 'http://linjiashop-mobile-api.microapp.store/file/getImgStream?idFile=';
  // ignore: sort_constructors_first
  SubItemGoods({Key key, this.goodsModleDataList}) :super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
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
      final double priceDouble = goodsModleDataList[i].price/100;
      mGoodsCard.add(InkWell(
          onTap: () {
            onItemClick(context,i);
          },
          child: ThemeCard(
            title: goodsModleDataList[i].name,
            price:'¥'+priceDouble.toStringAsFixed(2) ,
            imgUrl:imgUrl+goodsModleDataList[i].pic,
            descript: goodsModleDataList[i].descript,
            number: 'x'+goodsModleDataList[i].stock.toString(),
          )
      )
      );
    }
    content = Column(
      children: mGoodsCard,
    );
    return content;
  }

  void onItemClick(BuildContext context,int i){
   final String id = goodsModleDataList[i].skuId;

   // ignore: always_specify_types
   final Map<String, String> p = {'name':goodsModleDataList[i].name,'id':id};
   //Routes.instance.navigateToParams(context,Routes.PRODUCT_DETAILS,params: p);
   Routes.instance.navigateToParams(context,Routes.product_items_page,params: p);
  }
}