import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiwell_reservation/dao/new/favorite_dao.dart';
import 'package:jiwell_reservation/models/cart_goods_query_entity.dart';
import 'package:jiwell_reservation/models/new/spus_entity.dart';
import 'package:jiwell_reservation/receiver/event_bus.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/utils/dialog_utils.dart';
import 'package:jiwell_reservation/view/customize_appbar.dart';

import '../cart_bottom.dart';
import '../common.dart';
import '../view/app_topbar.dart';
import 'cart_item.dart';
import 'load_state_layout.dart';
import 'new/card_spus.dart';
import 'new/like_item.dart';
class LikePage extends StatefulWidget{
  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {

  LoadState _layoutState = LoadState.State_Loading;
  List<GoodsModel> goodsModels = [];
  List<SpusModel> googlist = [];

  bool _isLoading = false;
  bool _isAllCheck = true;
  LikeItem _cartItem;

  @override
  void initState() {
//    print("--*-- CartPage");
    _listen();
    super.initState();
    //_listen();
    _isLoading = true;
    loadSpuData();
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
  // Widget build(BuildContext context) {
  //   AppSize.init(context);
  //   return Scaffold(
  //       appBar: MyAppBar(
  //       preferredSize: Size.fromHeight(AppSize.height(160)),
  //       child: CustomRightBar(title:"喜欢的商品",onBack: () => Navigator.pop(context),onMenu: (){
  //         ToastUtil.buildToast("编辑商品");
  //       },menu: "编辑")),
  //       body:Center(
  //         child:Text(
  //           '商品列表',
  //           textDirection: TextDirection.ltr,
  //           style: TextStyle(
  //             fontSize: 40.0,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.yellow,
  //           ),
  //         ) ,
  //       ));
  //
  // }
  @override
  void dispose() {
    super.dispose();
    _clearSubscription.cancel();
  }

  ///返回不同頭部
  Widget _getHeader(BuildContext context) {
    //return CommonTopBar(title: '喜歡的商品',onBack: () => Navigator.pop(context));
    //return CustomRightBar(title:"喜歡的商品",onBack: () => Navigator.pop(context));
    return CommonBackTopBar(title: '我喜歡的商品', onBack:() {
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
      if (googlist.isEmpty) {
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
              const Text('沒有喜歡的商品'),
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
        _cartItem =  LikeItem(googlist);//CartItem(goodsModels);
        return Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: _cartItem,
            ),
            // Positioned(
            //   bottom: 0,
            //   left: 0,
            //   child: CartBottom(goodsModels, _isAllCheck),
            // )
          ],
        );
      }
    }
  }

  void loadSpuData() async {
    String token = AppConfig.token;
    final SpusEntity entity = await FavoriteDao.listFetch(token,AppConfig.userId);
    if (entity?.spusModelList != null) {
      googlist = entity?.spusModelList;
      setState(() {
        _isLoading = false;
        _layoutState = LoadState.State_Success;
      });
    }
    else{
      if (mounted) {
        setState(() {
          googlist.clear();
          _isLoading = false;
          _layoutState = LoadState.State_Empty;
        });
      }
    }

    // final CartGoodsQueryEntity entity = await CartQueryDao.fetch1( AppConfig.token);
    // if (entity?.goods != null) {
    //   if (entity.goods.isNotEmpty) {
    //     final List<GoodsModel> goodsModelsTmp = [];
    //     entity.goods.forEach((GoodsModel el) {
    //       goodsModelsTmp.add(el);
    //     });
    //     if (mounted) {
    //       setState(() {
    //         _isLoading = false;
    //         _layoutState = LoadState.State_Success;
    //         goodsModels.clear();
    //         goodsModels.addAll(goodsModelsTmp);
    //       });
    //     }
    //   } else {
    //     if (mounted) {
    //       setState(() {
    //         goodsModels.clear();
    //         _isLoading = false;
    //         _layoutState = LoadState.State_Success;
    //       });
    //     }
    //   }
    // } else {
    //   if (mounted) {
    //     setState(() {
    //       _isLoading = false;
    //       _layoutState = LoadState.State_Success;
    //       //AppConfig.token='';
    //     });
    //   }
    // }


  }

  StreamSubscription _clearSubscription;
  // StreamSubscription _loginSubscription;
  // StreamSubscription _removeSubscription;
  ///監聽Bus events
  void _listen() {
    _clearSubscription = eventBus.on<LikeNumInEvent>().listen((LikeNumInEvent event) {
      if (mounted) {
        if ('clear' == event.event) {
          setState(() {
            if (googlist.isEmpty) {
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
    // _loginSubscription = eventBus.on<UserLoggedInEvent>().listen((UserLoggedInEvent event) {
    //   if (mounted) {
    //     if (event.text == 'sucuss' ) {
    //       loadCartData();
    //     }
    //   }
    // });
    //
    // _removeSubscription =
    //     eventBus.on<GoodsRemoveInEvent>().listen((GoodsRemoveInEvent event) {
    //       if (mounted) {
    //         _cartItem.loadClearGoods(event.index);
    //       }
    //     });
  }

}