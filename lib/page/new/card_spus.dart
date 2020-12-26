import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jiwell_reservation/models/new/spus_entity.dart';
import 'package:jiwell_reservation/routes/routes.dart';
import 'package:jiwell_reservation/view/custom_view.dart';
// ignore: must_be_immutable


class CardSpus extends StatelessWidget {
  final List<SpusModel> goodsModleDataList;
  String imgUrl = 'http://linjiashop-mobile-api.microapp.store/file/getImgStream?idFile=';
  // ignore: sort_constructors_first
  CardSpus({Key key, this.goodsModleDataList}) :super(key: key);
  @override
  Widget build(BuildContext context) {
    initState();
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
      final double priceDouble = 20;//goodsModleDataList[i].price/100;
      mGoodsCard.add(InkWell(
          onTap: () {
            onItemClick(context,i);
          },
          child: SpusThemeCard(
            title: goodsModleDataList[i].title,
            price:'\$'+priceDouble.toString() ,
            imgUrl:goodsModleDataList[i].bname,
            descript: goodsModleDataList[i].subTitle,
            number: '100',//+goodsModleDataList[i].stock.toString(),
            clickCallback: (param){
              Routes.instance.navigateTo(context, Routes.comment_page);
            },
          )
      )
      );
    }
    content = Column(
      children: mGoodsCard,
    );
    return content;
  }

  //不要移除會過載使用
  @override
  void initState() {
  }

  void onItemClick(BuildContext context,int i){
    SpusModel spusModel = goodsModleDataList[i];
    String spuJsonString = jsonEncode(spusModel);
    final Map<String, dynamic> p = {'spusModelJson':spuJsonString};
    Routes.instance.navigateToParams(context,Routes.Product_Spec_page,params: p);
  }

  // Widget _buildBottomBar() {
  //   //return new BottomAppBar(
  //   return Container(
  //     height: 40.0,
  //     child: new Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: <Widget>[
  //         new Stack(
  //           children: <Widget>[
  //             new Icon(
  //               Icons.thumb_up,
  //               size: 20.0,
  //               color: Colors.grey,
  //             ),
  //             new Container(
  //               margin: const EdgeInsets.only(left: 24.0),
  //               child: new Text(
  //                 0 == _like ? '' : ('$_like'),
  //                 style: new TextStyle(fontSize: 12.0, color: Colors.grey),
  //               ),
  //             )
  //           ],
  //         ),
  //         new InkWell(
  //           onTap: () {
  //             //_showBottomPop(context);
  //           },
  //           child: new Icon(
  //             Icons.share,
  //             size: 20.0,
  //             color: Colors.grey,
  //           ),
  //         ),
  //         new InkWell(
  //           onTap: () {
  //             //RouteUtil.route2Comment(context, widget.id);
  //           },
  //           child: new Stack(
  //             children: <Widget>[
  //               new Icon(
  //                 Icons.message,
  //                 size: 20.0,
  //                 color: Colors.grey,
  //               ),
  //               new Container(
  //                 margin: const EdgeInsets.only(left: 24.0),
  //                 child: new Text(
  //                   0 == _commentsTotal ? '' : ('$_commentsTotal'),
  //                   style: new TextStyle(fontSize: 12.0, color: Colors.grey),
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  //   //);
  // }

}