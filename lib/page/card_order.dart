import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiwell_reservation/dao/new/delete_order_dao.dart';
import 'package:jiwell_reservation/models/cart_goods_query_entity.dart';
import 'package:jiwell_reservation/models/order_entity.dart';
import 'package:jiwell_reservation/receiver/event_bus.dart';
import 'package:jiwell_reservation/routes/routes.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/view/custom_view.dart';
import 'package:jiwell_reservation/view/theme_ui.dart';

import '../common.dart';
// ignore: must_be_immutable
class OrderCard extends StatelessWidget {

  final List<OrderModel> orderModleDataList;
  String imgUrl = 'http://linjiashop-mobile-api.microapp.store/file/getImgStream?idFile=';
  OrderCard({Key key, this.orderModleDataList}) :super(key: key);

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
    final List<Widget> mGoodsCard = [];
    Widget content;
    for (int i = 0; i < orderModleDataList.length; i++) {
      mGoodsCard.add(Container(
        width: AppSize.width(1080),
        child:Column(
          children: <Widget>[
            InkWell(
              onTap: (){
                onItemClick(context,i);
              },
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child:Container(
                        padding: const EdgeInsets.only(left: 10),
                        child:  Text('訂單編號:', style: ThemeTextStyle.orderFormStatusStyle,)
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child:
                    Container(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          orderModleDataList[i].statusName??'未知狀況',
                          textAlign: TextAlign.right,
                          style: ThemeTextStyle.detailStylePrice,)
                    )
                    ,flex: 1,
                  )
                ],
              ),
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    orderModleDataList[i].orderId,
                    textAlign: TextAlign.left,
                    style: ThemeTextStyle.cardTitleStyle,
                  ) ,
                )

              ],

            ),
            _buildOrderSub(orderModleDataList[i].goods),
            ThemeView.divider(),
            // ignore: prefer_if_elements_to_conditional_expressions, unnecessary_parenthesis
            ((orderModleDataList[i].status == 1 ? _buildPayStatusSub(context,i):SizedBox(
              height: AppSize.height(0.0))))
          ],
        ) ,
      ));

    }
    content = Column(
      children: mGoodsCard,
    );
    return content;
  }

  Widget _buildPayStatusSub(BuildContext context, int i){
    final Widget payStatusSub = SizedBox(
      height: AppSize.height(120.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          // ignore: always_specify_types
          children: [
            MaterialButton(
              color: Colors.white,
              textColor: Colors.grey,
              child: Text('取消訂單', style: ThemeTextStyle.orderFormStatusStyle),
              onPressed: () async {
                EasyLoading.showInfo('執行中..');
                final bool entity = await DeleteOrderDao.fetch(AppConfig.token,orderModleDataList[i].orderId);
                if(entity == true){
                  EasyLoading.showInfo('訂單己移除');
                  Timer(Duration(seconds:1), (){
                   EasyLoading.dismiss();
                   eventBus.fire(DeleteOrderInEvent());
                  });
                }
                else{
                  EasyLoading.showInfo('訂單移除失敗，請稍後在試');
                  Timer(Duration(seconds:1), (){
                    EasyLoading.dismiss();
                  });
                }
              },
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child:   MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('立即付款',style: ThemeTextStyle.orderStylePrice),
                onPressed: () {
                  final String totalPriceStr = orderModleDataList[i].totalPay.toString();
                  // ignore: always_specify_types
                  final Map<String, String> p = {'orderSn':orderModleDataList[i].orderId,'totalPrice':totalPriceStr};
                  Routes.instance.navigateToParams(context,Routes.pay_page,params: p);
                },
              ),
            )
            ,
          ]),
    );

    return payStatusSub;
  }

  Widget _buildOrderSub(List<GoodsModel> goodsModleDataList){
    // ignore: always_specify_types
    final List<Widget> mGoodsSubCard = [];
    Widget contentSub;
    for (int i = 0; i < goodsModleDataList.length; i++) {
      final int priceDouble = goodsModleDataList[i].price * goodsModleDataList[i].num;
      mGoodsSubCard.add(ThemeCard(
        title: goodsModleDataList[i].title,
        price:'\$'+priceDouble.toString(),
        imgUrl:imgUrl+goodsModleDataList[i].image,
        descript: goodsModleDataList[i].description,
        number: 'x'+goodsModleDataList[i].num.toString(),
      ));
    }
    contentSub = Column(
      children: mGoodsSubCard,
    );
    return contentSub;
  }
  void onItemClick(BuildContext context,int i){
    final String orderSn = orderModleDataList[i].orderId;
    // ignore: always_specify_types
    final Map<String, String> p = {'orderSn':orderSn};
    Routes.instance.navigateToParams(context,Routes.ORDER_DETAILS,params: p);
  }

}