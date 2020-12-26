
import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jiwell_reservation/common.dart';
import 'package:jiwell_reservation/dao/clear_goods_dao.dart';
import 'package:jiwell_reservation/dao/new/favorite_dao.dart';
import 'package:jiwell_reservation/models/cart_goods_query_entity.dart';
import 'package:jiwell_reservation/models/new/spus_entity.dart';
import 'package:jiwell_reservation/page/count_item.dart';

import 'package:jiwell_reservation/receiver/event_bus.dart';
import 'package:jiwell_reservation/routes/routes.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/utils/dialog_utils.dart';
import 'package:jiwell_reservation/utils/image_utils.dart';
import 'package:jiwell_reservation/view/custom_view.dart';
import 'package:jiwell_reservation/view/theme_ui.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';


// ignore: must_be_immutable
class couponItem extends StatelessWidget {
  //final  List<GoodsModel> goodsModels;
  List<SpusModel> googlist = [];
  BuildContext _context;
  // ignore: sort_constructors_first
  couponItem(this.googlist);
  String imgUrl = 'http://linjiashop-mobile-api.microapp.store/file/getImgStream?idFile=';
  @override
  Widget build(BuildContext context) {
//    print(item);
    _context = context;
    return Container(
        margin: const EdgeInsets.only(top: 5.0),
        padding:const EdgeInsets.all(3.0),
        child:  _buildWidget(context)
    );
  }

  Widget _buildWidget(BuildContext context) {
    // ignore: always_specify_types
    final List<Widget> mGoodsCard = [];
    Widget content;
    final double priceDouble = 20;
    for (int i = 0; i < googlist.length; i++) {

    }
    mGoodsCard.add(Container(
      height: AppSize.height(140),
    ));
    content = Column(
      children: mGoodsCard,
    );
    return content;
  }

  // ignore: avoid_void_async
  void loadClearGoods(int index) async{
    if(googlist.length == 0 || googlist.length < index){
      return;
    }
    final SharedPreferences prefs = await SharedPreferences
        .getInstance();
    final String token = prefs.getString('token');
    final bool entity = await FavoriteDao.deleteFetch(token,int.parse(AppConfig.userId),googlist[index].id);
    if (entity == true) {
          Navigator.of(_context).pop(true);
          googlist.removeAt(index);
          eventBus.fire(LikeNumInEvent('clear'));
        ToastUtil.buildToast('請求成功~');
    }
    else{
        ToastUtil.buildToast('請求失敗~');
    }
  }
  //多选按钮
  Widget _cartCheckBt(BuildContext context,GoodsModel item){
    return Expanded(
      child:Container(
        width: AppSize.width(150),
        height: AppSize.height(232),
        child:Checkbox(
                value: item.isCheck,
                activeColor:Colors.pink,
                onChanged: (bool val){
                  item.isCheck=val;
                  eventBus.fire(GoodsNumInEvent('state'));
                },
              )),

      flex: 1,
    );
  }
  //商品图片
  Widget _cartImage(GoodsModel item){

    return Container(
      width: AppSize.height(232),
      height: AppSize.height(232),
      margin: const EdgeInsets.only(left: 15),
      child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8)),
                // child: CachedNetworkImage(
                //   placeholder: (BuildContext context, String url) => const CircularProgressIndicator(),
                //   imageUrl: imgUrl+item.image,
                //   fit: BoxFit.cover,
                // )
               child: ImageUtils.getCachedNetworkImage(imgUrl+item.image,BoxFit.cover,null),),

//        child:Image.network(
//          imgUrl+item.pic,
//          fit: BoxFit.cover,
//        ),),

    );
  }
  //商品名称
  Widget _cartGoodsName(GoodsModel item,String token,int index){
    return
      Expanded(
        child: Container(
          width:AppSize.width(350),
          margin: const EdgeInsets.only(left: 10.0, top: 10.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(item.title, textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                  style: ThemeTextStyle.cardTitleStyle),
              Text(item.description, textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines:1,
                  softWrap: false,
                  style: ThemeTextStyle.cardTitleStyle),
              Text('NT ${item.price}',
                  maxLines: 1,
                  softWrap: false,
                  textAlign: TextAlign.left,
                  style: ThemeTextStyle.cardPriceStyle),
              CartCount(item,index)
            ],
          ),
        ),
        flex: 3,
      );
  }

  StreamSubscription _removeSubscription;
  void _listen() {
    _removeSubscription =
        eventBus.on<GoodsRemoveInEvent>().listen((GoodsRemoveInEvent event) {
           //loadClearGoods(_context,goodsModels[event.index].idSku,AppConfig.token,event.index);
          // showDialog<bool>(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return AlertDialog(
          //         title: const Text('提示？'),
          //         content: const Text('確定移除該商品？'),
          //         actions: <Widget>[
          //           FlatButton(
          //             child: const Text('取消'),
          //             onPressed: () => Navigator.of(context).pop(false),
          //           ),
          //           FlatButton(
          //             child: const Text('確定'),
          //             onPressed: () async {
          //               final SharedPreferences prefs = await SharedPreferences
          //                   .getInstance();
          //               final String token = prefs.getString('token');
          //               loadClearGoods(context,goodsModels[event.index].idSku,
          //                   token,event.index);
          //             },
          //           ),
          //         ],
          //       );
          //     }
          // );
        });
  }

  void onItemClick(BuildContext context,int i){
    SpusModel spusModel = googlist[i];
    String spuJsonString = jsonEncode(spusModel);
    final Map<String, dynamic> p = {'spusModelJson':spuJsonString};
    Routes.instance.navigateToParams(context,Routes.Product_Spec_page,params: p);
  }

  @override
  void dispose() {
    // ignore: flutter_style_todos
    // TODO: implement dispose
    _removeSubscription.cancel();
  }
}