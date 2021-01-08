import 'dart:async';

import 'package:color_dart/hex_color.dart';
import 'package:color_dart/rgba_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiwell_reservation/dao/new/coupon_dao.dart';
import 'package:jiwell_reservation/dao/new/favorite_dao.dart';
import 'package:jiwell_reservation/models/cart_goods_query_entity.dart';
import 'package:jiwell_reservation/models/new/coupon_entity.dart';
import 'package:jiwell_reservation/models/new/spus_entity.dart';
import 'package:jiwell_reservation/receiver/event_bus.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/view/app_topbar.dart';
import 'package:jiwell_reservation/view/customize_appbar.dart';

import '../../common.dart';
import '../../res/colours.dart';
import '../load_state_layout.dart';
import 'coupon/widgets/abutton.dart';
import 'coupon/widgets/coupon_row.dart';

class UseCouponPage extends StatefulWidget{
  @override
  _UseCouponPageState createState() => _UseCouponPageState();
}

class _UseCouponPageState extends State<UseCouponPage> {

  LoadState _layoutState = LoadState.State_Loading;
  List<CouponHistoryDetailModel> couponlist = [];

  bool _isLoading = false;
  CouponRow _cartItem;

  @override
  void initState() {
//    print("--*-- CartPage");
    _listen();
    super.initState();
    //_listen();
    _isLoading = true;
    loadUseCouponData();
  }

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    return Scaffold(
        appBar: MyAppBar(
          preferredSize: Size.fromHeight(AppSize.height(160.0)),
          child: _getHeader(context),
        ),
        body: LoadStateLayout(
            state: _layoutState,
            errorRetry: () {},
            successWidget: _getContent(context)));
  }
  @override
  void dispose() {
    super.dispose();
    _clearSubscription.cancel();
  }

  ///返回不同頭部
  Widget _getHeader(BuildContext context) {

    return CommonBackTopBar(title: '可使用優惠券', onBack:() {
      Navigator.pop(context);
    });//
  }

  Widget _getContent(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    else {
      if (couponlist.isEmpty) {
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
              const Text('沒有優惠券'),
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
      } else {
        //_cartItem =  CouponRow(googlist);//CartItem(goodsModels);
        // return Stack(
        //   children: <Widget>[
        //     SingleChildScrollView(
        //       child: _cartItem,
        //     ),
        //     // Positioned(
        //     //   bottom: 0,
        //     //   left: 0,
        //     //   child: CartBottom(goodsModels, _isAllCheck),
        //     // )
        //   ],
        // );
        double bottom = 20;
        return Stack(children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: ListView(
              padding: EdgeInsets.only(bottom: 80 + bottom),
              children: CouponRows()
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              color: Colours.white,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: bottom, top: bottom/2),
              width: MediaQuery.of(context).size.width,
              child: AButton.normal(
                  width: 300,
                  child: Text('保存'),
                  color: Colours.white,
                  bgColor: Colours.blue_1,
                  onPressed: () => {}
              ),
            ),
          )
        ],);
      }
    }
  }

  void loadUseCouponData() async {
    String token = AppConfig.token;
    final CouponHistoryDetailEntity entity = await UseCouponDao.cartListFetch(token,'1');
    if (entity?.couponHistoryDetailModelList != null) {
      couponlist = entity?.couponHistoryDetailModelList;
      setState(() {
        _isLoading = false;
        _layoutState = LoadState.State_Success;
      });
    }
    else{
      if (mounted) {
        setState(() {
          couponlist.clear();
          _isLoading = false;
          _layoutState = LoadState.State_Empty;
        });
      }
    }
    setState(() {
      _isLoading = false;
      _layoutState = LoadState.State_Success;
    });
  }

  StreamSubscription _clearSubscription;
  ///監聽Bus events
  void _listen() {
    _clearSubscription = eventBus.on<LikeNumInEvent>().listen((LikeNumInEvent event) {
      if (mounted) {
        if ('clear' == event.event) {
          setState(() {
            if (couponlist.isEmpty) {
              _layoutState = LoadState.State_Empty;
            }
          });
        }
        // else {
        //   ///除了刪除處理全選，添加操作
        //   if ('All' == event.event && googlist.isNotEmpty) {
        //     _isAllCheck = goodsModels[0].isCheck;
        //   } else {
        //     _isAllCheck = false;
        //   }
        //   setState(() {});
        // }
      }
    });
  }

  List<Widget>CouponRows(){
    List<Widget> couponRows = <Widget>[];
    couponlist.forEach((v) {
      CouponHistoryDetailModel couponHistoryDetailModel = v;
      couponRows.add(CouponRow(couponHistoryDetailModel.couponModel,true));
    });
    return couponRows;
  }
}
