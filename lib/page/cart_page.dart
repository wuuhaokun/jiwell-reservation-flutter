import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiwell_reservation/common.dart';
import 'package:jiwell_reservation/dao/cart_query_dao.dart';
import 'package:jiwell_reservation/models/cart_goods_query_entity.dart';
import 'package:jiwell_reservation/page/cart_item.dart';

import 'package:jiwell_reservation/receiver/event_bus.dart';
import 'package:jiwell_reservation/routes/routes.dart';
import 'package:jiwell_reservation/utils/app_size.dart';

import 'package:jiwell_reservation/view/app_topbar.dart';
import 'package:jiwell_reservation/view/customize_appbar.dart';
import 'package:jiwell_reservation/view/flutter_iconfont.dart';
import 'package:jiwell_reservation/view/my_icons.dart.dart';

import '../cart_bottom.dart';
import 'load_state_layout.dart';
import '../functions.dart';

// ignore: must_be_immutable
class CartPage extends StatefulWidget {
  String from = '';
  // ignore: sort_constructors_first
  CartPage({this.from});
  @override
  _CartPageState createState() => _CartPageState();
}
class _CartPageState extends State<CartPage>  {
  LoadState _layoutState = LoadState.State_Loading;
  List<GoodsModel> goodsModels = [];

  bool _isLoading = false;
  bool _isAllCheck = true;
  CartItem _cartItem;
  @override
  void initState() {
//    print("--*-- CartPage");
    super.initState();
    _listen();
    _isLoading = true;
    loadCartData();
  }

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    return Scaffold(
        appBar: MyAppBar(
          preferredSize: Size.fromHeight(AppSize.height(160.0)),
          child: _getHeader(),
        ),
        body: LoadStateLayout(
            state: _layoutState,
            errorRetry: () {},
            successWidget: _getContent(context)));
  }

  ///返回不同頭部
  Widget _getHeader() {
    if (widget.from != null && widget.from.isNotEmpty && widget.from != '') {
      return CommonBackTopBar(
          title: '購物車', onBack: () => Navigator.pop(context));
    } else {
      return CommonTopBar(
          title: '購物車');
    }
  }

  Widget _getContent(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      if( AppConfig == null || AppConfig.token == null || AppConfig.token.isEmpty){
        return Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 128,
              ),
              Icon(CupertinoIcons.shopping_cart, size: 128),
              const Text('還沒有登入'),
              Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: Material(
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius:
                          const BorderRadius.all(Radius.circular(25.0)),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25.0),
                          onTap: () {
                            final Map<String, String> p = {'index': '2'};
                            Routes.instance.navigateToParams(context, Routes.login_page, params: p);
                          },
                          child: Container(
                            width: 300.0,
                            height: 50.0,
                            //设置child 居中
                            alignment: const Alignment(0, 0),
                            child: Text(
                              '立即登入',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        );
      }else if(goodsModels.isEmpty){
        return Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 128,
              ),
              Icon(CupertinoIcons.shopping_cart, size: 128),
              const Text('購物車是空的'),
              Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: Material(
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius:
                          const BorderRadius.all(Radius.circular(25.0)),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25.0),
                          onTap: () {
                            //Routes.instance
                            //    .navigateTo(context, Routes.ROOT);
                            eventBus.fire(IndexInEvent('0'));
                          },
                          child: Container(
                            width: 300.0,
                            height: 50.0,
                            //设置child 居中
                            alignment: const Alignment(0, 0),
                            child: Text(
                              '去逛逛',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        );
      }else{
        _cartItem = CartItem(goodsModels);
        return Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: _cartItem,
            ),
            Positioned(
              bottom:  AppSize.height(150.0),
              left: 0,
              child:_useCouponView(title:'我的優惠',con:Icon(MyIcons.youhuiquanholder),onGoCouponCallback:() {
                Routes.instance.navigateTo(context, Routes.use_coupon_page);
                return;
              }),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: CartBottom(goodsModels, _isAllCheck),
            )
          ],
        );
      }
    }
  }

  // ignore: avoid_void_async
  void loadCartData() async {
    //final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (null == AppConfig.token ||AppConfig.token.isEmpty) {
      setState(() {
        _isLoading = false;
        _layoutState = LoadState.State_Success;
      });
      return;
    }
    final CartGoodsQueryEntity entity = await CartQueryDao.fetch1( AppConfig.token);
    if (entity?.goods != null) {
      if (entity.goods.isNotEmpty) {
        final List<GoodsModel> goodsModelsTmp = [];
        entity.goods.forEach((GoodsModel el) {
          goodsModelsTmp.add(el);
        });
        if (mounted) {
          setState(() {
            _isLoading = false;
            _layoutState = LoadState.State_Success;
            goodsModels.clear();
            goodsModels.addAll(goodsModelsTmp);
          });
        }
      } else {
        if (mounted) {
          setState(() {
            goodsModels.clear();
            _isLoading = false;
            _layoutState = LoadState.State_Success;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _layoutState = LoadState.State_Success;
          //AppConfig.token='';
        });
      }
    }
  }

  StreamSubscription _clearSubscription;
  StreamSubscription _loginSubscription;
  StreamSubscription _removeSubscription;
  ///監聽Bus events
  void _listen() {
    _clearSubscription = eventBus.on<GoodsNumInEvent>().listen((GoodsNumInEvent event) {
      if (mounted) {
        if ('clear' == event.event) {
          setState(() {
            if (goodsModels.isEmpty) {
              _layoutState = LoadState.State_Empty;
            }
          });
        } else {
          ///除了刪除處理全選，添加操作
          if ('All' == event.event && goodsModels.isNotEmpty) {
            _isAllCheck = goodsModels[0].isCheck;
          } else {
            _isAllCheck = false;
          }
          setState(() {});
        }
      }
    });
    _loginSubscription = eventBus.on<UserLoggedInEvent>().listen((UserLoggedInEvent event) {
      if (mounted) {
        if (event.text == 'sucuss' ) {
          loadCartData();
        }
      }
    });

    _removeSubscription =
        eventBus.on<GoodsRemoveInEvent>().listen((GoodsRemoveInEvent event) {
          if (mounted) {
            _cartItem.loadClearGoods(event.index);
          }
        });
  }

  Widget _useCouponView({String title, Icon con, OnGoCouponCallback onGoCouponCallback}) {
    return InkWell(
      onTap:onGoCouponCallback ,
      child:  Container(
        margin: const EdgeInsets.all(5.0),
        height:AppSize.height(140.0) ,
        color: Colors.white,
        width:AppSize.width(1080),
        // decoration: BoxDecoration(
        //     color: Colors.white,
        //     border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: ListTile(
          leading: con,
          title: Text(title,style: TextStyle(
              color: Colors.red, fontSize: 14.0)),
          trailing: Icon(IconFonts.arrow_right),
        ),
      ) ,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _loginSubscription.cancel();
    _clearSubscription.cancel();
    _removeSubscription.cancel();
  }
}
