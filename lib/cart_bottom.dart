
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiwell_reservation/models/cart_goods_query_entity.dart';
import 'package:jiwell_reservation/routes/routes.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/shipping_entity.dart';
import 'receiver/event_bus.dart';
import 'package:jiwell_reservation/common.dart';
import 'package:jiwell_reservation/dao/save_order_dao.dart';
import 'package:jiwell_reservation/dao/shipping_address_dao.dart';

// ignore: must_be_immutable
class CartBottom extends StatelessWidget {

  List<GoodsModel> list;
  bool isAllCheck;
  // ignore: sort_constructors_first
  CartBottom(this.list,this.isAllCheck);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(5.0),
        height:AppSize.height(140.0) ,
        color: Colors.white,
        width:AppSize.width(1080),
        child: Row(
              children: <Widget>[
                selectAllBtn(),
                allPriceArea(),
                goButton(context)
              ],
            )
        );
  }

  //全選按鈕
  Widget selectAllBtn(){
    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
            value: isAllCheck,
            activeColor: Colors.pink,
            onChanged: (bool val){
              // ignore: avoid_function_literals_in_foreach_calls
              list.forEach((GoodsModel el){
                el.isCheck= val;
              });
              eventBus.fire(GoodsNumInEvent('All'));
            },
          ),
          const Text('全選')
        ],
      ),
    );
  }
  double allPrice=0;
  // 合計區域
  Widget allPriceArea(){

    // ignore: avoid_function_literals_in_foreach_calls
    list.forEach((GoodsModel el){
      if(el.isCheck){
        allPrice=allPrice+ el.countNum*(el.price);
      }
    });
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                width: AppSize.width(220),
                height:AppSize.height(140) ,
                child: Text(
                    '合計:',
                    style:TextStyle(
                        fontSize: AppSize.sp(36)
                    )
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: AppSize.width(240),
                child: Text(
                    '\$${allPrice}',
                    style:TextStyle(
                      fontSize:AppSize.sp(36),
                      color: Colors.red,
                    )
                ),
              )
            ],
          ),
        ],
      ),
    );

  }

  //结算按钮
  Widget goButton(BuildContext context){
    int  allGoodsCount=0;
    int isAll=0;
    // ignore: avoid_function_literals_in_foreach_calls
    list.forEach((GoodsModel el){
      if(el.isCheck){
        isAll++;
        allGoodsCount=allGoodsCount+ el.countNum;
      }
    });
    if(isAll==list.length){
      eventBus.fire(GoodsNumInEvent('All'));
    }
    return Container(
      width:AppSize.width(360),
      padding: const EdgeInsets.only(left: 30),
      child:InkWell(
        onTap: () async {
          ShippingAddresEntry shippingAddresEntry = await ShippingAddressDao.fetch(AppConfig.token);
          ShippingAddressModel defaultAddress = ShippingAddressModel();
          if (shippingAddresEntry?.shippingAddressModels != null) {
            if (shippingAddresEntry.shippingAddressModels.length > 0) {
              final List<ShippingAddressModel> shippingAddressTemp = [];
              shippingAddresEntry.shippingAddressModels.forEach((shippingAddressModel) {
                if (shippingAddressModel.defaultAddress) {
                      defaultAddress = shippingAddressModel;
                }
                shippingAddressTemp.add(shippingAddressModel);
              });
            } else {
             // if (mounted) {
             //   setState(() {
             //     _layoutState = LoadState.State_Empty;
             //   });
             // }
            }
          }
          ///////////////////////////////////////////////////////////
          DateTime createTime = DateTime.now();
          final String createTimeString  = '2020-04-21T20:57:53.000+0000';//"2018-06-06T20:55:18.000+0000";//createTime.to.toIso8601String();
          final List<dynamic> listArray = [];

          final double totalPay = allPrice.toDouble();//int.parse(allPrice.toStringAsFixed(2));
          list.forEach((GoodsModel el){
            if(el.isCheck == true) {
              final Map<String, dynamic> content = {
                'orderId': '',
                'skuId': el.skuId.toString(),
                'num': el.countNum,
                'title': el.title,
                'ownSpec': el.ownSpec,
                'description': el.description
                ,
                'price': el.price,
                'image': el.image
              };
              listArray.add(content);
            }
          });

          final String shippingName = '黑貓通-台丸';//物流名稱
          final String shippingCode = '14579828266';//物流單號
          final String buyerMessage = '速速送達-不得有誤';
          String buyerNick = AppConfig.nickName;
          final bool buyerRate = false; //買家是否已經評價
          final String receiverState = '台灣';//省份
          final String receiverCity = defaultAddress.city;//城市
          final String receiverDistrict = defaultAddress.district;//區/縣
          final String receiverAddress = defaultAddress.address;
          final String receiverMobile = defaultAddress.phone;
          final String receiverZip = defaultAddress.zipCode;
          final String receiver = defaultAddress.name;
          final int invoiceType = 0;//發票類型，0無發票，1普通發票，2電子發票，3增值稅發票
          final int sourceType = 1;//訂單來源 1:app端，2：pc端，3：M端，4：微信端，5：手機qq端

          // ignore: always_specify_types
          final Map<String,dynamic>params = {'totalPay':totalPay,'actualPay':totalPay,'userId':AppConfig.userId,
            'promotionIds'   :''              ,'paymentType'   :2             ,'postFee'         :100             ,
            'createTime'     :createTimeString,'shippingName'  :shippingName  ,'shippingCode'    :shippingCode    ,
            'buyerMessage'   :buyerMessage    ,'buyerNick'     :buyerNick     ,'buyerRate'       :buyerRate       ,
            'receiverState'  :receiverState   , 'receiverCity' :receiverCity  ,'receiverDistrict':receiverDistrict,
            'receiverAddress':receiverAddress ,'receiverMobile':receiverMobile,'receiverZip'     :receiverZip     ,
            'receiver'       :receiver        ,'invoiceType'   :invoiceType   ,'sourceType'      :sourceType      ,
            'orderDetails'   :listArray };
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String orderId = await SaveOrderDao.fetch(params,prefs.getString('token'));
          if(orderId != null){
            final Map<String, String> params = {'orderSn':orderId,'totalPrice':totalPay.toString()};
            Routes.instance.navigateToParams(context,Routes.pay_page,params:params);
          }
          else{
            EasyLoading.showInfo('訂單生成失敗，請稍後在試');
            Timer(Duration(seconds:1), (){
              EasyLoading.dismiss();
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(3.0)
          ),
          child: Text(
            '結算($allGoodsCount)',
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
      ) ,
    );
  }
}