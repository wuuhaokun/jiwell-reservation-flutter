import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiwell_reservation/common.dart';
import 'package:jiwell_reservation/dao/user_dao.dart';
import 'package:jiwell_reservation/models/user_entity.dart';


import 'package:jiwell_reservation/page/cart_page.dart';
import 'package:jiwell_reservation/page/member_page.dart';

import 'package:jiwell_reservation/page/search_page.dart';

import 'package:jiwell_reservation/receiver/event_bus.dart';
import 'package:jiwell_reservation/routes/routes.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/utils/connectivity_utils.dart';

import 'package:jiwell_reservation/utils/dialog_utils.dart';
import 'package:jiwell_reservation/view/new/check_update.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'classify_page.dart';
import 'home_shop_page.dart';
import 'new/spu_search_page.dart';

class IndexPage extends StatefulWidget {

  @override
  _IndexPageState createState() => _IndexPageState();
}

final List<BottomNavigationBarItem> bottomBar = <BottomNavigationBarItem>[
  BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), title: Text("小鋪")),
//  BottomNavigationBarItem(icon: Icon(CupertinoIcons.profile_circled), title: Text("分類")),
  BottomNavigationBarItem(icon: Icon(CupertinoIcons.search), title: Text("搜索")),
  BottomNavigationBarItem(icon: Icon(CupertinoIcons.shopping_cart), title: Text("購物車")),
  BottomNavigationBarItem(icon: Icon(CupertinoIcons.profile_circled), title: Text("我的"))
];

final List<Widget> pages = <Widget>[
  HomePage(),
//  ClassifyPage(),
  //SearchPage(),
  SpuSearchPage(),
  CartPage(),
  MemberPage(),
];

class _IndexPageState extends State<IndexPage>  with AutomaticKeepAliveClientMixin ,WidgetsBindingObserver{

  DateTime lastPopTime;
  String token;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    AppConfig.loadUserInfo();
    WidgetsBinding.instance.addObserver(this);
//    print("--*-- _IndexPageState");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //
    //_clearPreferences();
    // 初始化屏幕适配包
    AppSize.init(context);
    _listen();
    Future.delayed(Duration(milliseconds: 1), () {
      CheckUpdate().check(context);
    });
    return WillPopScope(

      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: (int index) async{
              if(ConnectivityUtils.connectStatus == ConnectivityResult.none){
                ToastUtil.buildToast('網絡無法連接,請打開網路後再試！！');
                return;
              }
              if(index == 3) {

                final SharedPreferences prefs = await SharedPreferences
                    .getInstance();
                if (null == prefs.getString('token')||prefs.getString('token').isEmpty) {
                  //Routes.instance.navigateTo(context, Routes.login_page);
                  final Map<String, String> p = {'index':'3'};
                  Routes.instance.navigateToParams(
                      context, Routes.login_page,
                      params: p);
                  return;
                }
                AppConfig.token = prefs.getString('token');
                AppConfig.loadUserInfo();
                setState(() {
                  currentIndex = index;
                  pageController.jumpToPage(index);
                });

              }else{
                setState(() {
                  currentIndex = index;
                  pageController.jumpToPage(index);
                });
              }
            },
            items: bottomBar),
        body: _getPageBody(context),
      ) ,
        // ignore: missing_return
        onWillPop:  ()async{
          // 点击返回键的操作
          if (lastPopTime == null ||
              DateTime.now().difference(lastPopTime) > const Duration(seconds: 2)) {
            lastPopTime = DateTime.now();
            ToastUtil.buildToast('再按一次退出');
          // ignore: missing_return
          } else {
            lastPopTime = DateTime.now();
            // 退出app
           return await SystemChannels.platform.invokeMethod('SystemNavigator.pop');

          }
        }
    );

  }

  @override //要加入 WidgetsBindingObserver
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      // user returned to our app
      print('AppLifecycleState.resumed');
      CheckUpdate().check(context);
    }else if(state == AppLifecycleState.inactive){
      // app is inactive
      print('AppLifecycleState.inactive');
    }else if(state == AppLifecycleState.paused){
      // user is about quit our app temporally
      print('AppLifecycleState.paused');
    }
    else if(state == AppLifecycleState.detached){
      // app suspended (not used in iOS)
      print('AppLifecycleState.detached');
    }
  }

  final PageController pageController = PageController();
  Widget _getPageBody(BuildContext context){
         return PageView(
            controller: pageController,
            children: pages,
            physics: const NeverScrollableScrollPhysics(), // 禁止滑动
          );
  }
  // ignore: always_specify_types
  StreamSubscription _indexSubscription;

  @override
  // ignore: flutter_style_todos
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  void _listen() {
    _indexSubscription = eventBus.on<IndexInEvent>().listen((IndexInEvent event) {
      final int index = int.parse(event.index);
      pageController.jumpToPage(index);
      setState(() {
        currentIndex = index;
      });
    });
  }
  @override
  void dispose() {
    // ignore: flutter_style_todos
    // TODO: implement dispose
    super.dispose();
    _indexSubscription.cancel();
  }

  // loadUserInfo() async {
  //   final SharedPreferences prefs = await SharedPreferences
  //       .getInstance();
  //   AppConfig.token = prefs.getString('token');
  //   if(AppConfig.token == null || AppConfig.token.isEmpty){
  //     return;
  //   }
  //   final UserEntity entity = await UserDao.fetch(AppConfig.token);
  //   if (entity?.userInfoModel != null) {
  //     AppConfig.nickName=entity.userInfoModel.nickName;
  //     AppConfig.mobile=entity.userInfoModel.mobile;
  //     AppConfig.avatar=entity.userInfoModel.avatar;
  //     AppConfig.gender=entity.userInfoModel.gender;
  //     AppConfig.userId=entity.userInfoModel.id;
  //     //AppConfig.registerFirebaseToken();
  //   }
  // }

}
