import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:jiwell_reservation/page/new/coupon/widgets/abutton.dart';
import 'package:jiwell_reservation/page/new/coupon/widgets/coupon_row.dart';
import 'package:jiwell_reservation/page/new/coupon/widgets/custom_appbar.dart';
// import 'package:flutter_luckin_coffee/components/a_button/index.dart';
// /
// import 'package:flutter_luckin_coffee/utils/global.dart';

class Coupon extends StatefulWidget {
  Coupon({Key key}) : super(key: key);

  _CouponState createState() => _CouponState();
}


class _CouponState extends State<Coupon> {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  /// 获取当前的context
  //static BuildContext getCurrentContext() => navigatorKey.currentContext;
  double bottom = 20;//MediaQuery.of(navigatorKey.currentContext).padding.bottom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        title: '可使用优惠券',
        context: context,
      ),
      body: Stack(children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: ListView(
              padding: EdgeInsets.only(bottom: 80 + bottom),
              children: <Widget>[
                CouponRow(null,false),
                CouponRow(null,false),
                CouponRow(null,false),
              ],
            ),
          ),
          
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              color: hex('#fff'),
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: bottom, top: bottom/2),
              width: MediaQuery.of(context).size.width,
              child: AButton.normal(
                width: 300,
                child: Text('保存'),
                color: hex('#fff'),
                bgColor: rgba(144, 192, 239, 1),
                onPressed: () => {}
              ),
            ),
          )
        ],),
    );
  }
}


