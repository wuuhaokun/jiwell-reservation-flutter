import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiwell_reservation/dao/user_dao.dart';
import 'package:jiwell_reservation/functions.dart';
import 'package:jiwell_reservation/models/user_entity.dart';
import 'package:jiwell_reservation/routes/routes.dart';
import 'package:jiwell_reservation/utils/app_size.dart';

import 'package:jiwell_reservation/view/app_topbar.dart';
import 'package:jiwell_reservation/view/customize_appbar.dart';
import 'package:jiwell_reservation/view/flutter_iconfont.dart';
import 'package:jiwell_reservation/view/my_icons.dart.dart';
import 'package:jiwell_reservation/view/ratingbar.dart';

//http://192.168.43.78:10010/api/item/goods/spu/page
import '../common.dart';
import 'load_state_layout.dart';

class MemberPage extends StatefulWidget {
  // MemberPage({this.from});
  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  LoadState _layoutState = LoadState.State_Loading;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    return Scaffold(
        appBar: MyAppBar(
          preferredSize: Size.fromHeight(AppSize.height(160.0)),
          child: CommonTopBar(title: '個人資訊'),
        ),
        body: LoadStateLayout(
            state: _layoutState,
            errorRetry: () {},
            successWidget: _getContent(context)));
  }

  Widget _getContent(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      if(AppConfig.isCanUsing == true){
        return ListView(
                  children: <Widget>[
                    _topHeader(),
                    _orderType(context),
                    _orderTitle(context),
                    _actionList(context),
                    //StarRatingBarWidget(onRatingCallback:_ratingChangeCallback,rating : 0.0,starCount:5,starSize:AppSize.width(60.0),color:Colors.red),
                  ],
                );
      }
    }
  }

  //头像区域
  Widget _topHeader() {
    return Container(
      width: double.infinity,
      height: AppSize.height(450),
      child: const Image(fit: BoxFit.fill, image: AssetImage('images/banner.png')),
    );
  }
  void initState() {
    _isLoading = true;
    // if(AppConfig.isCanUsing == false) {
    //   _layoutState =  LoadState.State_Empty;
    // }
    // else{
    //   _layoutState = LoadState.State_Success;
    // }
    loadData();
//    print("--*-- _IndexPageState");
  }

  void loadData() async {
    await AppConfig.loadUserInfo();
    _isLoading = false;
    setState(() {
      if(AppConfig.isCanUsing == false) {
        _layoutState =  LoadState.State_Empty;
      }
      else{
        _layoutState = LoadState.State_Success;
      }
    });
    // if(AppConfig.isCanUsing == true) {
    //   _layoutState =  LoadState.State_Error;
    // }
    // else{
    //   _layoutState = LoadState.State_Success;
    // }
  }
  //typedef void RatingChangeCallback(double rating);
  void _ratingChangeCallback(double rating){
    print("--*-- _IndexPageState");
  }
  //我的订单顶部
  Widget _orderTitle(BuildContext context) {
    return InkWell(
      onTap: () {
        AppConfig.orderIndex = 0;
        Routes.instance.navigateTo(context, Routes.order_page);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: ListTile(
          leading: Icon(Icons.assignment),
          title: const Text('全部訂單'),
          trailing: Icon(IconFonts.arrow_right),
        ),
      ),
    );
  }

  Widget _orderType(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      width: AppSize.width(1080),
      height: AppSize.height(160),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () {
              AppConfig.orderIndex = 0;
              Routes.instance.navigateTo(context, Routes.order_page);
            },
            child: Container(
              width: AppSize.width(270),
              child: Column(
                children: <Widget>[
                  Icon(
                    MyIcons.daifukuan,
                    size: 30,
                  ),
                  const Text('未付款'),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              AppConfig.orderIndex = 1;
              Routes.instance.navigateTo(context, Routes.order_page);
            },
            child: Container(
              width: AppSize.width(270),
              child: Column(
                children: <Widget>[
                  Icon(
                    MyIcons.daifahuo,
                    size: 30,
                  ),
                  const Text('未發貨'),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              AppConfig.orderIndex = 2;
              Routes.instance.navigateTo(context, Routes.order_page);
            },
            child: Container(
              width: AppSize.width(270),
              child: Column(
                children: <Widget>[
                  Icon(
                    MyIcons.yifahuo,
                    size: 30,
                  ),
                  const Text('已發貨'),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              AppConfig.orderIndex = 3;
              Routes.instance.navigateTo(context, Routes.order_page);
            },
            child: Container(
              width: AppSize.width(270),
              child: Column(
                children: <Widget>[
                  Icon(
                    MyIcons.yiwancheng,
                    size: 30,
                  ),
                  const Text('交易成功'),
                ],
              ),
            ),
          ),
//          InkWell(
//            onTap: () {
//              AppConfig.orderIndex = 4;
//              Routes.instance.navigateTo(context, Routes.order_page);
//            },
//            child: Container(
//              width: AppSize.width(270),
//              child: Column(
//                children: <Widget>[
//                  Icon(
//                    MyIcons.yiwancheng,
//                    size: 30,
//                  ),
//                  Text('交易關閉'),
//                ],
//              ),
//            ),
//          ),
//          InkWell(
//            onTap: () {
//              AppConfig.orderIndex = 5;
//              Routes.instance.navigateTo(context, Routes.order_page);
//            },
//            child: Container(
//              width: AppSize.width(270),
//              child: Column(
//                children: <Widget>[
//                  Icon(
//                    MyIcons.yiwancheng,
//                    size: 30,
//                  ),
//                  Text('已評價'),
//                ],
//              ),
//            ),
//          )
        ],
      ),
    );
  }
//
  Widget _myListTile({String title, Icon con, OnGoMineCallback onGoMineCallback}) {
    return InkWell(
      onTap:onGoMineCallback ,
      child:  Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: ListTile(
          leading: con,
          title: Text(title),
          trailing: Icon(IconFonts.arrow_right),
        ),
      ) ,
    );

  }

  Widget _actionList(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _myListTile(title:'收貨地址',con:Icon(MyIcons.addressholder),onGoMineCallback:()
          {
            Routes.instance.navigateTo(context, Routes.address_page);
            return;
          }),
          _myListTile(title:'我的收藏',con:Icon(Icons.star_border),onGoMineCallback:()
          {
            Routes.instance.navigateTo(context, Routes.like_goods_page);
            return;
          }),
//          _myListTile(title:'我的积分',con:Icon(MyIcons.jifenholder),onGoMineCallback:()
//          {
//            Routes.instance.navigateTo(context, Routes.address_page);
//          }),
         _myListTile(title:'我的優惠券',con:Icon(MyIcons.youhuiquanholder),onGoMineCallback:()
         {
           Routes.instance.navigateTo(context, Routes.coupon_page);
           //Routes.instance.navigateTo(context, Routes.comment_page);
           // final Map<String, String> p = {'themeId': '1'};
           // Routes.instance.navigateToParams(context, Routes.comment_page, params: p);
           return;
         }),
//          _myListTile(title:'我的礼物',con:Icon(MyIcons.liwuholder),onGoMineCallback:()
//          {
//            Routes.instance.navigateTo(context, Routes.address_page);
//          }),
          _myListTile(title:'設置',con:Icon(CupertinoIcons.gear_big),onGoMineCallback:() {
            final Map<String, String> p = {'index': ''};
            Routes.instance.navigateToParams(context, Routes.setting_page, params: p);
            //Routes.instance.navigateTo(context, Routes.setting_page);
            return;
          }),
        ],
      ),
    );
  }

  // ignore: always_declare_return_types
  // _loadUserInfo() async {
  //   final UserEntity entity = await UserDao.fetch(AppConfig.token);
  //   if (entity?.userInfoModel != null) {
  //     AppConfig.nickName=entity.userInfoModel.nickName;
  //     AppConfig.mobile=entity.userInfoModel.mobile;
  //     AppConfig.avatar=entity.userInfoModel.avatar;
  //     AppConfig.gender=entity.userInfoModel.gender;
  //   }
  // }

  Future<void> _checkLogin(BuildContext context) async {
//    final SharedPreferences prefs = await SharedPreferences
//        .getInstance();
//    if (null == prefs.getString('token')||prefs.getString('token').isEmpty) {
//      Routes.instance.navigateTo(context, Routes.login_page);
//      return;
//    }
//    AppConfig.token = prefs.getString('token');
//    _loadUserInfo();
  }

}
