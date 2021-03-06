
import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jiwell_reservation/common.dart';
import 'package:jiwell_reservation/dao/clear_goods_dao.dart';
import 'package:jiwell_reservation/models/cart_goods_query_entity.dart';
import 'package:jiwell_reservation/page/count_item.dart';

import 'package:jiwell_reservation/receiver/event_bus.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/utils/dialog_utils.dart';
import 'package:jiwell_reservation/utils/image_utils.dart';
import 'package:jiwell_reservation/view/theme_ui.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common.dart';


// ignore: must_be_immutable
class CartItem extends StatelessWidget {
  final  List<GoodsModel> goodsModels;
  BuildContext _context;
  // ignore: sort_constructors_first
  CartItem(this.goodsModels);
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
    for (int i = 0; i < goodsModels.length; i++) {
      mGoodsCard.add(Slidable(
        key: Key(i.toString()),
        actionPane: const SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child:Container(
          //height: AppSize.height(350),
          margin: const EdgeInsets.fromLTRB(5.0,2.0,5.0,2.0),
          padding: const EdgeInsets.fromLTRB(5.0,10.0,5.0,10.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(width:1,color:Colors.black12)
              )
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _cartCheckBt(context,goodsModels[i]),
              _cartImage(goodsModels[i]),
              _cartGoodsName(goodsModels[i],AppConfig.token,i),
            ],
          ),
        ) ,
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: '移除',
            color: Colors.red,
            icon: Icons.delete,
            closeOnTap: true,
            onTap: (){
              return
                showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('提示？'),
                      content: const Text('確定移除該商品？'),
                      actions: <Widget>[
                        FlatButton(
                          child: const Text('取消'),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        FlatButton(
                          child: const Text('確定'),
                          onPressed: () async {
                            final SharedPreferences prefs = await SharedPreferences
                                .getInstance();
                            final String token = prefs.getString('token');
                            loadClearGoods(i);
                          },
                        ),
                      ],
                    );
                  }
              );
            },
          ),
        ],
      ));
    }
    mGoodsCard.add(Container(
      height: AppSize.height(140),
    ));
    content = Column(
      children: mGoodsCard,
    );
    return content;
  }

  // @override
  // void initState() {
  //   _listen();
  // }
  // String _getDescription(String ownSpec){
  //   //String ownSpec = '';
  //   //Map<String,dynamic> map = jsonDecode(ownSpec);
  //   //map.forEach((key, value) {
  //   //  ownSpec = ownSpec + key + value;
  //   //});
  //   return '大杯，去冰，全糖，不加料';
  //   //return
  // }
  
  // ignore: avoid_void_async
  void loadClearGoods(int index) async{
    if(goodsModels.length == 0 || goodsModels.length < index){
      return;
    }
    final SharedPreferences prefs = await SharedPreferences
        .getInstance();
    final String token = prefs.getString('token');
    String orderId = goodsModels[index].skuId;
    final bool entity = await ClearDao.fetch1(orderId,token);
    if(entity != null && entity == true){
      Navigator.of(_context).pop(true);
      goodsModels.removeAt(index);
      eventBus.fire(GoodsNumInEvent('clear'));
      ToastUtil.buildToast('請求成功~');
    }else{
      final Map<String, String> p = {'index': '-1'};
      //Routes.instance.navigateToParams(context, Routes.login_page, params: p);
      //AppConfig.token  = '';
      ToastUtil.buildToast('請求失敗~');
    }

//    MsgEntity entity = await ClearDao.fetch(orderId,token);
//    if(entity?.msgModel != null){
//      if(entity.msgModel.code==20000){
//        Navigator.of(context).pop(true);
//        goodsModels.removeAt(index);
//        eventBus.fire(new GoodsNumInEvent("clear"));
//      }
//      ToastUtil.buildToast(entity.msgModel.msg);
//    }else{
//      Routes.instance.navigateTo(context, Routes.login_page);
//      AppConfig.token  = '';
//      ToastUtil.buildToast("請求失敗~");
//
//    }
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

  // void loadClearGoods(BuildContext context,String orderId,String token,int index) async{
  //   if(goodsModels.length == 0 || goodsModels.length < index){
  //     return;
  //   }
  //   final bool entity = await ClearDao.fetch1(orderId,token);
  //   if(entity != null && entity == true){
  //     Navigator.of(context).pop(true);
  //     goodsModels.removeAt(index);
  //     eventBus.fire(GoodsNumInEvent('clear'));
  //     ToastUtil.buildToast('請求成功~');
  //   }else{
  //     final Map<String, String> p = {'index': '-1'};
  //     //Routes.instance.navigateToParams(context, Routes.login_page, params: p);
  //     //AppConfig.token  = '';
  //     ToastUtil.buildToast('請求失敗~');
  //   }
  // }

  // _useCouponView(title:'收貨地址',con:Icon(MyIcons.addressholder),onGoCouponCallback:()
  // {
  // Routes.instance.navigateTo(context, Routes.address_page);
  // return;
  // }),

  @override
  void dispose() {
    // ignore: flutter_style_todos
    // TODO: implement dispose
    _removeSubscription.cancel();
  }
}