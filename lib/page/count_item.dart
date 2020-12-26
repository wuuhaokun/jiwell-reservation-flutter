
import 'package:flutter/material.dart';
import 'package:jiwell_reservation/dao/add_goods_cart_dao.dart';
import 'package:jiwell_reservation/dao/del_goods_dao.dart';
import 'package:jiwell_reservation/dao/new/update_goods_dao.dart';

import 'package:jiwell_reservation/models/cart_entity.dart';
import 'package:jiwell_reservation/models/cart_goods_query_entity.dart';
import 'package:jiwell_reservation/models/msg_entity.dart';

import 'package:jiwell_reservation/receiver/event_bus.dart';
import 'package:jiwell_reservation/routes/routes.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/utils/dialog_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common.dart';
// ignore: directives_ordering
import 'package:jiwell_reservation/common.dart';


// ignore: must_be_immutable
class CartCount extends StatelessWidget {
  GoodsModel item;
  int index;
  // ignore: sort_constructors_first
  CartCount(this.item,this.index);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.width(190.0),
      height:AppSize.width(65),
      margin: const EdgeInsets.only(top:5.0),
      decoration: BoxDecoration(
          border:Border.all(width: 1 , color:Colors.black12)
      ),
      child: Row(
        children: <Widget>[
          _reduceBtn(context),
          _countArea(),
          _addBtn(context),
        ],
      ),

    );
  }
  // 减少按钮
  Widget _reduceBtn(BuildContext context){
    return InkWell(
      onTap: () async {
        final int carNum =  item.countNum - 1;
        final SharedPreferences prefs = await SharedPreferences
            .getInstance();
        final String token = prefs.getString('token');

        if(carNum == 0){
          //eventBus.fire(GoodsRemoveInEvent('sub',index));
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
                        //Navigator.of(context).pop(false);
                        eventBus.fire(GoodsRemoveInEvent('sub',index));
                        //           ToastUtil.buildToast('請求成功~');
                        //final SharedPreferences prefs = await SharedPreferences
                        //    .getInstance();
                        // final String token = prefs.getString('token');
                        // loadClearGoods(context,goodsModels[event.index].idSku,
                        //     token,event.index);
                      },
                    ),
                  ],
                );
              }
          );

          //eventBus.fire(GoodsRemoveInEvent('sub',index));
          // AlertDialog(
          //   title: const Text('提示？'),
          //   content: const Text('確定移除該商品？'),
          //   actions: <Widget>[
          //     FlatButton(
          //       child: const Text('取消'),
          //       onPressed: () {
          //         //item.countNum++;
          //       }
          //     ),
          //     FlatButton(
          //       child: const Text('確定'),
          //       onPressed: () async {
          //         final bool entity = await DelDao.fetch1(item.idSku,token);
          //         if(entity != null && entity == true){
          //           //item.countNum--;
          //           eventBus.fire(GoodsRemoveInEvent('sub',index));
          //           ToastUtil.buildToast('請求成功~');
          //         }else{
          //           //final Map<String, String> p = {'index': '-1'};
          //           //Routes.instance.navigateToParams(context, Routes.login_page, params: p);
          //           //AppConfig.token = '';
          //           //item.countNum++;
          //           ToastUtil.buildToast('請求失敗~');
          //         }
          //       },
          //     ),
          //   ],
          // );
        }
        else if(carNum < 0){
          return;
        }
        else {
          loadReduce(context, item.skuId, carNum, token);
        }
      },
      child: Container(
        width:AppSize.width(55),
        height:AppSize.width(55),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            //color: item.countNum>1?Colors.white:Colors.black12,
            color: Colors.white,
            border:Border(
                right:BorderSide(width:1,color:Colors.black12)
            )
        ),
        child:const Text('-'),
      ),
    );
  }
  // ignore: avoid_void_async
  void loadReduce(BuildContext context,String orderId,int count,String token) async{
    final bool entity = await updateDao.fetch1(orderId,count,token);
    if(entity != null && entity == true){
      item.countNum--;
      eventBus.fire(GoodsNumInEvent('sub'));
      ToastUtil.buildToast('請求成功~');
    }else{
      //Routes.instance.navigateTo(context, Routes.login_page);
      // ignore: always_specify_types
      final Map<String, String> p = {'index': '-1'};
      Routes.instance.navigateToParams(context, Routes.login_page, params: p);
      AppConfig.token = '';
      ToastUtil.buildToast('請求失敗~');
    }

//    MsgEntity entity = await DelDao.fetch1(orderId,count,token);
//    if(entity?.msgModel != null){
//      if(entity.msgModel.code==20000){
//        item.countNum--;
//        eventBus.fire(new GoodsNumInEvent("sub"));
//      }
//      ToastUtil.buildToast(entity.msgModel.msg);
//    }else{
//
//      Routes.instance.navigateTo(context, Routes.login_page);
//      AppConfig.token = '';
//      ToastUtil.buildToast('請求失敗~');
//    }

  }

  //添加按钮
  Widget _addBtn(BuildContext context){
    return InkWell(
      onTap: (){
        final int carNum =  item.countNum + 1;
        addCart(context,item.skuId,carNum,item.skuId,AppConfig.token);
      },
      child: Container(
        width:AppSize.width(55),
        height:AppSize.width(55),
        alignment: Alignment.center,

        decoration: BoxDecoration(
            color: Colors.white,
            border:Border(
                left:BorderSide(width:1,color:Colors.black12)
            )
        ),
        child: const Text('+'),
      ),
    );
  }
  // ignore: avoid_void_async
  void addCart(BuildContext context,String idGoods,int count,String idSku,String token) async{
    //以下Kun先移除之後要打開
//    CartEntity entity = await AddDao.fetch(idGoods,count,idSku,token);
//    if(entity?.cartModel != null){
//      if(entity.cartModel.code==20000){
//        item.countNum++;
//        eventBus.fire(GoodsNumInEvent("add"));
//      }
//      ToastUtil.buildToast(entity.cartModel.msg);
//    }else{
//      Routes.instance.navigateTo(context, Routes.login_page);
//      AppConfig.token  = '';
//      ToastUtil.buildToast('請求失敗~');
//
//    }
    final bool entity = await updateDao.fetch1(idSku,count,token);
    if(entity != null && entity == true){
      item.countNum++;
      eventBus.fire(GoodsNumInEvent('sub'));
      ToastUtil.buildToast('請求成功~');
    }else{
      //Routes.instance.navigateTo(context, Routes.login_page);
      Map<String, String> p = {'index': '-1'};
      Routes.instance.navigateToParams(context, Routes.login_page, params: p);
      AppConfig.token = '';
      ToastUtil.buildToast('請求失敗~');
    }
  }

  //中间数量显示区域
  Widget _countArea(){
    return Container(
      width:AppSize.width(70),
      height:AppSize.width(45),
      alignment: Alignment.center,
      color: Colors.white,
      child: Text('${item.countNum}'),
    );
  }

}