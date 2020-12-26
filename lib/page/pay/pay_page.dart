import 'dart:convert';
import 'dart:io';

import 'package:jiwell_reservation/utils/dialog_utils.dart';
//import 'package:fluwx/fluwx.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/view/app_topbar.dart';
import 'package:jiwell_reservation/view/customize_appbar.dart';
import 'package:jiwell_reservation/view/my_icons.dart.dart';
import 'package:jiwell_reservation/view/theme_ui.dart';
//import 'package:fluwx/fluwx.dart' as fluwx;
import 'dart:io' as H;
class PayPage extends StatefulWidget {
  final String orderSn;
  final String totalPrice;

  PayPage({this.orderSn, this.totalPrice});

  @override
  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  int _radioGroupPay = 0;
  String _url = "https://wxpay.wxutil.com/pub_v2/app/app_pay.php";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initFluwx();
  }

  void _handleRadioValueChanged(int value) {
    setState(() {
      _radioGroupPay = value;
    });
  }

  Widget _getContent() {
    return Stack(children: <Widget>[
      Container(
          color: ThemeColor.appBg,
          child: Column(
            children: <Widget>[
              _myListTile('訂單編號', widget.orderSn, ThemeTextStyle.detailStyle),
              _myListTile('應付金額', '¥' + widget.totalPrice,
                  ThemeTextStyle.detailStylePrice),
              _myListTileIcon(
                  Icon(
                    MyIcons.weixinpay,
                    size: 30,
                    color: Colors.green,
                  ),
                  0),
              ThemeView.divider(),
              _myListTileIcon(
                  Icon(MyIcons.zhifubpay, size: 40, color: Colors.blue), 1),
            ],
          )),
      Positioned(bottom: 0, left: 0, child: _btnBottom())
    ]);
  }

  Widget _btnBottom() {
    return InkWell(
      onTap: () {
        _launchPayURL();
      },
      child: Container(
        alignment: Alignment.center,
        width: AppSize.width(1080),
        height: AppSize.height(160),
        color: Colors.green,
        child: Text(
          '立即支付',
          style: TextStyle(color: Colors.white, fontSize: AppSize.sp(54)),
        ),
      ),
    );
  }
  _initFluwx() async {
    // await registerWxApi(
    //     appId: "wxd930ea5d5a258f4f",
    //     doOnAndroid: true,
    //     doOnIOS: true,
    //     universalLink: "https://your.univerallink.com/link/");
    // var result = await isWeChatInstalled;
    // print("is installed $result");
  }
  Widget _myListTileIcon(Icon con, int index) {
    return Container(
      height: AppSize.height(180.0),
      color: Colors.white,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10),
            child: con,
          ),
          Expanded(
            child: Container(
                padding: EdgeInsets.only(right: 10),
                alignment: Alignment.centerRight,
                child: Checkbox(
                  value: _radioGroupPay == index,
                  activeColor: Colors.pink,
                  onChanged: (bool val) {
                    _handleRadioValueChanged(index);
                  },
                )),
            flex: 1,
          )
        ],
      ),
    );
  }

  Widget _myListTile(String title, String subTitle, TextStyle style) {
    return Container(
      height: AppSize.height(120.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  title,
                  style: ThemeTextStyle.personalShopNameStyle,
                )),
            flex: 1,
          ),
          Expanded(
            child: Container(
                padding: EdgeInsets.only(right: 10),
                child: Text(
                  subTitle,
                  textAlign: TextAlign.right,
                  style: style,
                )),
            flex: 1,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    AppSize.init(context);
    return Scaffold(
        appBar: MyAppBar(
          preferredSize: Size.fromHeight(AppSize.height(160)),
          child: CommonBackTopBar(
              title: '收銀台', onBack: () => Navigator.pop(context)),
        ),
        body: _getContent());
  }

  _launchPayURL()  async {
    if(_radioGroupPay==0){
      // var h = H.HttpClient();
      // h.badCertificateCallback = (cert, String host, int port) {
      //   return true;
      // };
      // var request = await h.getUrl(Uri.parse(_url));
      // var response = await request.close();
      // var data = await Utf8Decoder().bind(response).join();
      // Map<String, dynamic> result = json.decode(data);
      // print(result['appid']);
      // print(result["timestamp"]);
      // fluwx.payWithWeChat(
      //   appId: result['appid'].toString(),
      //   partnerId: result['partnerid'].toString(),
      //   prepayId: result['prepayid'].toString(),
      //   packageValue: result['package'].toString(),
      //   nonceStr: result['noncestr'].toString(),
      //   timeStamp: result['timestamp'],
      //   sign: result['sign'].toString(),
      // )
      //     .then((data) {
      //   print("---》$data");
      // });

      //{"appid":"wxb4ba3c02aa476ea1","partnerid":"1900006771","package":"Sign=WXPay","noncestr":"cb95340dc755c827db9307ee782a86eb","timestamp":1591691487,"prepayid":"wx091631275493778597885d451734449032","sign":"2633A3CE9C98E01F36B32F8655185FD9"}
    }else{
      ToastUtil.buildToast("正在開發");
    }

  }
}
