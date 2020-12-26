
import 'package:flutter/material.dart';
import 'package:jiwell_reservation/common.dart';
import 'package:jiwell_reservation/dao/new/update_goods_dao.dart';

import 'package:jiwell_reservation/models/cart_goods_query_entity.dart';
import 'package:jiwell_reservation/models/msg_entity.dart';

import 'package:jiwell_reservation/receiver/event_bus.dart';
import 'package:jiwell_reservation/routes/routes.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/utils/dialog_utils.dart';

// ignore: must_be_immutable
class CartDetailCount extends StatelessWidget {
  GoodsModel item;

  // ignore: sort_constructors_first
  CartDetailCount(this.item);
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
      onTap: (){
        loadReduce(context,item.skuId,item.countNum-1,AppConfig.token);
      },
      child: Container(
        width:AppSize.width(55),
        height:AppSize.width(55),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: item.countNum>1?Colors.white:Colors.black12,
            border:Border(
                right:BorderSide(width:1,color:Colors.black12)
            )
        ),
        child:item.countNum>1? const Text('-'):const Text(' '),
      ),
    );
  }

  // ignore: avoid_void_async
  void loadReduce(BuildContext context,String orderId,int count,String token) async{

    final MsgEntity entity = await updateDao.fetch(orderId,count,token);
    if(entity?.msgModel != null){
      if(entity.msgModel.code==20000){
        item.countNum--;
        eventBus.fire(GoodsNumInEvent('sub'));
      }
      ToastUtil.buildToast(entity.msgModel.msg);
    }else{
      //Routes.instance.navigateTo(context, Routes.login_page);
      //Routes.instance.navigateTo(context, Routes.login_page);
      // ignore: always_specify_types
      final Map<String, String> p = {'index': '-1'};
      Routes.instance.navigateToParams(context, Routes.login_page, params: p);
      AppConfig.token  = '';
      ToastUtil.buildToast('請求失敗~');
    }

  }

  //添加按钮
  Widget _addBtn(BuildContext context){
    return InkWell(
      onTap: (){
        addCart(context,item.userId,1,AppConfig.token);
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
  void addCart(BuildContext context,String idGoods,int count,String token) async{
    return;
    //以下Kun先移除之後要打開
//    CartEntity entity = await AddDao.fetch(idGoods,count,"",token);
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
//    }

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