import 'package:flutter/material.dart';
import 'package:jiwell_reservation/common.dart';

import 'package:jiwell_reservation/dao/order_detail_dao.dart';
import 'package:jiwell_reservation/models/order_detail_entity.dart';
import 'package:jiwell_reservation/page/load_state_layout.dart';

import 'package:jiwell_reservation/res/colours.dart';
import 'package:jiwell_reservation/routes/routes.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/view/app_topbar.dart';
import 'package:jiwell_reservation/view/custom_view.dart';
import 'package:jiwell_reservation/view/customize_appbar.dart';
import 'package:jiwell_reservation/view/theme_ui.dart';

import 'package:url_launcher/url_launcher.dart';


///
/// 訂單詳情頁
///
class OrderDetails extends StatefulWidget {
  final String orderSn;

  OrderDetails({this.orderSn});

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails>{
  LoadState _layoutState = LoadState.State_Loading;
  OrderDetailModel orderDetailModel;
  final String imgUrl =
      "http://linjiashop-mobile-api.microapp.store/file/getImgStream?idFile=";

  @override
  void initState() {
    Future.microtask(() =>
        loadData()
    );

    super.initState();
  }

  // ignore: avoid_void_async
  void loadData() async {
    // ignore: prefer_final_locals
    final OrderDetailEntry entity =
    await OrderDetailDao.fetch(widget.orderSn, AppConfig.token);
    if (null != entity) {
      orderDetailModel = entity.orderDetailModel;
      setState(() {
        _layoutState = LoadState.State_Success;
      });
    } else {
      setState(() {
        _layoutState = LoadState.State_Error;
      });
    }
  }

  /**
   * 構建訂單地址信息
   */
  Widget _getAddress() {
    if (orderDetailModel.province.contains('北京') ||
        orderDetailModel.province.contains("重慶") ||
        orderDetailModel.province.contains("天津") ||
        orderDetailModel.province.contains("上海") ||
        orderDetailModel.province.contains("深圳") ||
        orderDetailModel.province.contains("香港") ||
        orderDetailModel.province.contains("澳門")) {
      return Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.all(10.0),
         
          child: Text(
            orderDetailModel.city +
                orderDetailModel.district +
                orderDetailModel.addressDetail,
            style: ThemeTextStyle.orderFormStatusStyle,
          ));
    } else {
      return Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.all(10.0),
          child: Text(
            orderDetailModel.province +
                orderDetailModel.city +
                orderDetailModel.district +
                orderDetailModel.addressDetail,
            style: ThemeTextStyle.orderFormStatusStyle,
          ));
    }
  }

  Widget _getOrderSn() {
    return Container(
      width: double.infinity,
      height: AppSize.height(120.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                '訂單編號:',
                style: ThemeTextStyle.orderFormStatusStyle,
              )),
          Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                orderDetailModel.orderSn,
                style: ThemeTextStyle.orderFormStatusStyle,
              ))
        ],
      ) ,
    );
  }

  ///構建訂單商品信息
  Widget _buildOrderWidget() {
    List<Widget> mGoodsCard = [];
    Widget content;
    for (int i = 0; i < orderDetailModel.goods.length; i++) {
      double priceDouble = orderDetailModel.goods[i].price / 100;
      mGoodsCard.add(InkWell(
          onTap: () => Navigator.pop(context),
          child: ThemeCard(
            title: orderDetailModel.goods[i].title,
            price: '¥' + priceDouble.toStringAsFixed(2),
            imgUrl: imgUrl + orderDetailModel.goods[i].image,
            descript: orderDetailModel.goods[i].description,
            number: 'x' + orderDetailModel.goods[i].num.toString(),
          ))
      );
    }
    content = Column(
      children: mGoodsCard,
    );
    return content;
  }
  ///撥打電話聯繫客服
  _launchURL() async {
    final String number = "tel:+95105555";
    if (await canLaunch(number)) {
      await launch(number);
    } else {
      throw 'Could not launch $number';
    }
  }
  Widget _getContent() {
    if (null == orderDetailModel) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return SingleChildScrollView(
        child: Container(
          color: ThemeColor.appBg,
          child: Column(
            children: <Widget>[
              Container(
                height: AppSize.height(120.0),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            orderDetailModel.name + "   " + orderDetailModel.tel,
                            style: ThemeTextStyle.orderFormStatusStyle,
                          )),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            orderDetailModel.statusName,
                            textAlign: TextAlign.right,
                            style: ThemeTextStyle.detailStylePrice,
                          )),
                      flex: 1,
                    )
                  ],
                ),
              ),
              ThemeView.divider(),
              _getAddress(),
              ThemeView.divider(),
              Container(
                height: AppSize.height(160.0),
                color: Colors.white,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MaterialButton(
                          color: Colors.white,
                          textColor: Colors.grey,
                          child: Text('連絡客服',
                              style: ThemeTextStyle.orderFormStatusStyle),
                          onPressed: () => _launchURL()

                      ),
                      Container(
                        margin: EdgeInsets.only(left:10,right: 10),
                        child: MaterialButton(
                          color: Colors.red,
                          textColor: Colors.white,
                          child:
                          Text('立即付款', style: ThemeTextStyle.orderStylePrice),
                          onPressed: () {
                            String totalPriceStr = (orderDetailModel.totalPrice / 100).toStringAsFixed(2);
                            Map<String, String> p={"orderSn":widget.orderSn,"totalPrice":totalPriceStr};
                            Routes.instance.navigateToParams(context,Routes.pay_page,params: p);
                          },
                        ),
                      ),
                    ]),
              ),
              Container(
                height: AppSize.height(40.0),
                color: Colours.divider,
                width: double.infinity,
              ),
              _getOrderSn(),
              ThemeView.divider(),
              _buildOrderWidget(),
              ThemeView.divider(),
              Container(
                height: AppSize.height(120.0),
                width: double.infinity,
                padding: EdgeInsets.only(right: 10.0),
                alignment: Alignment.centerRight,
                color: Colours.white,
                child: Text(
                  '合計:' + (orderDetailModel.totalPrice / 100).toStringAsFixed(2),
                  style: ThemeTextStyle.orderFormStatusStyle,
                ),
              ),
              ThemeView.divider(),
              _getOrderSn(),
              ThemeView.divider(),
              Container(
                height: AppSize.height(120.0),
                width: double.infinity,
                color: Colours.white,
                padding: EdgeInsets.only(left: 10.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  '備註:',
                  style: ThemeTextStyle.orderFormStatusStyle,
                ),
              ),
              ThemeView.divider(),
              Container(
                height: AppSize.height(120.0),
                width: double.infinity,
                color: Colours.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            '創建時間',
                            style: ThemeTextStyle.orderFormStatusStyle,
                          )),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            orderDetailModel.createTime,
                            textAlign: TextAlign.right,
                            style: ThemeTextStyle.orderFormStatusStyle,
                          )),
                      flex: 1,
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    AppSize.init(context);

    return Scaffold(
        appBar: MyAppBar(
          preferredSize: Size.fromHeight(AppSize.height(160.0)),
          child: CommonBackTopBar(
              title: "訂單詳情", onBack: () => Navigator.pop(context)),
        ),
        body: LoadStateLayout(
            state: _layoutState,
            errorRetry: () {
              setState(() {
                _layoutState = LoadState.State_Loading;
              });

              loadData();
            },
            successWidget: _getContent()
        )
    );
  }
}
