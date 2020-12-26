import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiwell_reservation/common.dart';

import 'package:jiwell_reservation/dao/add_goods_cart_dao.dart';
import 'package:jiwell_reservation/dao/add_like_dao.dart';
import 'package:jiwell_reservation/dao/cart_query_dao.dart';
import 'package:jiwell_reservation/dao/details_dao.dart';
import 'package:jiwell_reservation/dao/is_like_dao.dart';
import 'package:jiwell_reservation/models/cart_goods_query_entity.dart';
import 'package:jiwell_reservation/models/details_entity.dart';
import 'package:jiwell_reservation/models/msg_entity.dart';
import 'package:jiwell_reservation/models/msg_like_entity.dart';
import 'package:jiwell_reservation/page/details_top_area.dart';
import 'package:jiwell_reservation/page/load_state_layout.dart';
import 'package:jiwell_reservation/page/specifica_button.dart';

import 'package:jiwell_reservation/receiver/event_bus.dart';
import 'package:jiwell_reservation/res/colours.dart';
import 'package:jiwell_reservation/routes/routes.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/utils/dialog_utils.dart';
import 'package:jiwell_reservation/view/app_topbar.dart';
import 'package:jiwell_reservation/view/custom_view.dart';
import 'package:jiwell_reservation/view/customize_appbar.dart';
import 'package:jiwell_reservation/view/theme_ui.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:shared_preferences/shared_preferences.dart';

///
/// 商品詳情頁
///
class ProductDetails extends StatefulWidget {
  final String id;

  // ignore: sort_constructors_first
  const ProductDetails({this.id});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails>  {
  int num = 0;
  final String imgUrl =
      'http://linjiashop-mobile-api.microapp.store/file/getImgStream?idFile=';
  LoadState _loadStateDetails = LoadState.State_Loading;
  GoodsModelDetail goodsModel;
  SkuModel skuModel;
  listModel model = listModel();
  // ignore: always_specify_types
  StreamSubscription _spcSubscription;
  // ignore: always_specify_types
  StreamSubscription _carSubscription;

  @override
  void initState() {
    _listen();
    isLike=false;
    if (mounted) {
      loadData();
      loadLike();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _spcSubscription.cancel();
    _carSubscription.cancel();
  }
  // ignore: avoid_void_async
  void loadLike() async{
    if(AppConfig.token.isNotEmpty) {
      final MsgLikeEntity entityLike = await LikeDao.fetch(AppConfig.token,widget.id);
      if (entityLike != null) {
        setState(() {
          isLike = entityLike.msgModel.data;
        });

      } else {
        ToastUtil.buildToast('失敗');
      }
    }
}


  ///
  /// 監聽Bus events
  void _listen() {
    _spcSubscription = eventBus.on<SpecEvent>().listen((SpecEvent event) {
      if (mounted && skuModel.listModels != null) {
        // ignore: avoid_function_literals_in_foreach_calls
        skuModel.listModels.forEach((listModel e) {
          if (e.code == event.code) {
            model = e;
          }
          setState(() {});
        });
      }
    });

    _carSubscription = eventBus.on<ToCarPageInEvent>().listen((ToCarPageInEvent event) {
      if (mounted) {
        final Map<String, String> p = {'from': 'from_product_details_to_car_page'};
        Routes.instance.navigateToParams(context, Routes.car_page, params: p);
      }
    });

  }
  bool isLike ;

  // ignore: avoid_void_async
  void loadData() async {
    if (mounted) {
      final DetailsEntity entity = await DetailsDao.fetch(widget.id.toString());
      if (entity?.goods != null) {
        goodsModel = entity.goods.goodsModelDetail;
        urls.clear();
        if (goodsModel.gallery != null && goodsModel.gallery.isNotEmpty && goodsModel.gallery.contains(',')) {
          urls = goodsModel.gallery.split(',');
          setState(() {
            _loadStateDetails = LoadState.State_Success;
          });
        }
        skuModel = entity.goods.skuModel;
        if (skuModel!= null && skuModel.listModels!= null && skuModel.listModels.isNotEmpty) {
          model = skuModel.listModels[0];
        }
      } else {
        setState(() {
          _loadStateDetails = LoadState.State_Error;
        });
      }
    }

  }

  List<String> urls = List();

  @override
  Widget build(BuildContext context) {
    //_listen();
    AppSize.init(context);
    return Scaffold(
        appBar: MyAppBar(
          preferredSize: Size.fromHeight(AppSize.height(160)),
          child: _getHeader(),
        ),
        body: LoadStateLayout(
            state: _loadStateDetails,
            errorRetry: () {
              setState(() {
                _loadStateDetails = LoadState.State_Loading;
              });
              loadData();
            },
            successWidget: _getContent()));
  }

  ///返回不同頭部
  Widget _getHeader() {
    if (null == goodsModel) {
      return CommonBackTopBar(
          title: '詳情', onBack: () => Navigator.pop(context));
    } else {
      return CommonBackTopBar(
          title: goodsModel.name, onBack: () => Navigator.pop(context));
    }
  }

  Widget _getBody() {

    return goodsModel.isOnSale
        ? Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  DetailsTopArea(
                      gallery: [],//''urls',//kun editing
                      descript: goodsModel.descript,
                      name: goodsModel.name,
                      num: goodsModel.num,
                      price: goodsModel.price),
                  Html(data: goodsModel.detail)
                ],
              ),
              Positioned(bottom: 0, left: 0, child: detailBottom())
            ],
          )
        : Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(

              children: <Widget>[
                Image.asset(
                  'images/ic_empty_shop.png',
                  height: 256,
                  width: 256,
                ),
                const Text('該商品己下架'),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child:Center(
                    child:Material(
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(const Radius.circular(25.0)),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25.0),
                          onTap: ()  {
                            Routes.instance.navigateTo(context,Routes.ROOT);
                          },
                          child: Container(
                            width: 300.0,
                            height: 50.0,
                            //设置child 居中
                            alignment: const Alignment(0, 0),
                            child: Text('去看看其他商品',style: TextStyle(color: Colors.white,fontSize: 16.0),),
                          ),
                        ),
                      ),
                    ),
                  )
                ),
              ],
            ),
          );
  }

  ///返回内容
  Widget _getContent() {
    if (null == goodsModel) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return _getBody();
    }
  }
  // ignore: avoid_void_async
  void addLike(String idGoods, String token) async {
    final MsgEntity entity = await AddLikeDao.fetch(token, idGoods);
    if (entity?.msgModel != null) {
      if (entity.msgModel.code == 20000) {
        ToastUtil.buildToast('收藏成功');
        setState(() {
          isLike = true;
        });
      }

    } else {
      ToastUtil.buildToast('收藏失敗');
    }
  }
  /// 底部詳情
  Widget detailBottom() {
    return Container(
      width: AppSize.width(1500),
      color: Colors.white,
      height: AppSize.width(160),
      child: Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              InkWell(
                onTap: () {
                  if (AppConfig.token == null||AppConfig.token.isEmpty) {
                    // ignore: always_specify_types
                    final Map<String, String> p = {'index': 'from_product_details_to_car_page'};
                    Routes.instance.navigateToParams(context, Routes.login_page, params: p);
                    return;
                  }
                  // ignore: always_specify_types
                  final Map<String, String> p = {'from': 'from_product_details_to_car_page'};
                  Routes.instance.navigateToParams(context, Routes.car_page, params: p);
//                  Navigator.pop(context);
//                  eventBus.fire(IndexInEvent('2'));
////                  Navigator.pop(context);
                },
                child: Container(
                  width: AppSize.width(300),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.shopping_cart,
                    size: 35,
                    color: Colors.red,
                  ),
                ),
              ),

              num == 0
                  ? Container()
                  : Positioned(
                      top: 0,
                      right: 10,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                        decoration: BoxDecoration(
                            color: Colors.pink,
                            border: Border.all(width: 2, color: Colors.white),
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Text(
                          num.toString(),
                          style: TextStyle(
                              color: Colors.white, fontSize: AppSize.sp(22)),
                        ),
                      ),
                    )
            ],
          ),
          Container(
            width: AppSize.width(1),
            height: AppSize.height(160),
            color: ThemeColor.subTextColor,
          ),
          InkWell(
            onTap: (){
              if(!isLike){
                  if (AppConfig.token==null||AppConfig.token.isEmpty) {
                    //Routes.instance.navigateTo(context, Routes.login_page);
                    //Routes.instance.navigateTo(context, Routes.login_page);
                    // ignore: always_specify_types
                    final Map<String, String> p = {'index': '-1'};
                    //final Map<String, String> p = {'index': 'from_product_details'};
                    Routes.instance.navigateToParams(context, Routes.login_page, params: p);
                  return;
                  }
                  addLike(widget.id,AppConfig.token);
                  }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: AppSize.width(30)),
              child: IconBtn(Icons.star_border,text: '收藏',textStyle:
                  isLike?ThemeTextStyle.priceStyle: ThemeTextStyle.orderContentStyle,
             iconColor: isLike?Colours.lable_clour:ThemeColor.subTextColor
              ),
            ) ,
          ),
          InkWell(
            onTap: () async {
              if (AppConfig.token==null||AppConfig.token.isEmpty) {
//                Routes.instance.navigateTo(context, Routes.login_page);
                final Map<String, String> p = {'index': 'from_product_details_to_car_page'};
                Routes.instance.navigateToParams(context, Routes.login_page, params: p);
                return;
              }
              showBottomMenu();
            },
            child: Container(
            alignment: Alignment.center,
            width: AppSize.width(350),
            height: AppSize.height(160),
            color: Colors.green,
            child: Text(
              '加入購物車',
              style: TextStyle(color: Colors.white, fontSize: AppSize.sp(54)),
            ),
          ),
          ),
          InkWell(
            onTap: () {
              if (AppConfig.token.isEmpty) {
//                Routes.instance.navigateTo(context, Routes.login_page);
                //Map<String, String> p = {'index': '-1'};
                final Map<String, String> p = {'index': 'from_product_details_to_car_page'};
                Routes.instance.navigateToParams(context, Routes.login_page, params: p);
                return;
              }
              eventBus.fire(IndexInEvent('2'));
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.center,
              width: AppSize.width(350),
              height: AppSize.height(160),
              color: Colors.red,
              child: Text(
                '馬上購買',
                style: TextStyle(color: Colors.white, fontSize: AppSize.sp(54)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //void addCart(String idGoods, int count, String idSku, String token) async {
    //CartEntity entity = await AddDao.fetch(idGoods, count, idSku, token);
  void addCart(String title,int count,String idSku,double price,String image,String ownSpec,String description,String token) async {
    bool entity = await AddDao.fetch1(title,count,idSku,price,image,ownSpec,description,token);
    if(entity != null && entity == true) {
      setState(() {
        num++;
      });
      Navigator.pop(context);
      ToastUtil.buildToast('加入成功');
    }
    else{
          ToastUtil.buildToast('添加購物車失敗');
    }
//    if (entity?.cartModel != null) {
//      if (entity.cartModel.code == 20000) {
//        setState(() {
//          num++;
//        });
//      }
//      Navigator.pop(context);
//      ToastUtil.buildToast(entity.cartModel.msg);
//    } else {
//      ToastUtil.buildToast('添加購物車失敗');
//    }
  }

  var descTextStyle1 =
      TextStyle(fontSize: AppSize.sp(35), color: ThemeColor.subTextColor);

  void showBottomMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Stack(children: <Widget>[
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              height: (skuModel.listModels == null || skuModel.listModels.isEmpty) ? 170.0 : 600.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSize.width(30),
                        vertical: AppSize.height(30)),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: AppSize.width(30)),
                          child: Image.network(imgUrl + '${urls[0]}',
                              width: AppSize.width(220),
                              height: AppSize.width(220)),
                        ),
                        Expanded(child: buildInfo()),
                      ],
                    ),
                  ),
                  (skuModel.listModels == null || skuModel.listModels.isEmpty)
                      ? Container()
                      : Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: AppSize.width(30)),
                            child: Scrollbar(
                              child: SingleChildScrollView(
                                  child: SpecificaButton(
                                      treeModel: skuModel.treeModel)),
                            ),
                          ),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 4, horizontal: AppSize.width(60)),
                          child: RaisedButton(
                            highlightColor: ThemeColor.appBarBottomBg,
                            onPressed: () {

                              //if (skuModel.listModels == null || skuModel.listModels.isEmpty) {
                                //addCart(widget.id, 1, '', AppConfig.token);
                              //} else {
                                //addCart(widget.id, 1, model.id, AppConfig.token);
                                addCart(goodsModel.name, 1, goodsModel.id, goodsModel.price.toDouble(),goodsModel.pic,goodsModel.specifications,/*goodsModel.description*/'', AppConfig.token);
                              //}
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            textColor: Colors.white,
                            color: ThemeColor.appBarTopBg,
                            child: const Text('確定'),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )),
          Positioned(
              top: 0,
              right: 0,
              child: Container(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    CupertinoIcons.clear_thick_circled,
                    size: 30,
                  ),
                ),
              ))
        ]);
      },
    );
  }

  Widget buildInfo() {
    return (skuModel.listModels == null || skuModel.listModels.isEmpty)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(goodsModel.name,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                  style: ThemeTextStyle.primaryStyle),
              Text.rich(TextSpan(
                  text: '¥' + (goodsModel.price / 100).toStringAsFixed(2),
                  style: ThemeTextStyle.cardPriceStyle,
                  children: [
                    TextSpan(text: '+', style: descTextStyle1),
                    const TextSpan(text: '60'),
                    TextSpan(text: '積分', style: descTextStyle1)
                  ])),
              Text('庫存:' + goodsModel.num.toString(), style: descTextStyle1)
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(goodsModel.name,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                  style: ThemeTextStyle.primaryStyle),
              Text.rich(TextSpan(
                  text: '¥' + (model.price / 100).toStringAsFixed(2),
                  style: ThemeTextStyle.cardPriceStyle,
                  children: [
                    TextSpan(text: '+', style: descTextStyle1),
                    const TextSpan(text: '60'),
                    TextSpan(text: '積分', style: descTextStyle1)
                  ])),
              Text('庫存:' + model.stock_num.toString(), style: descTextStyle1)
            ],
          );
  }

  void loadCartData(String token) async {
    final CartGoodsQueryEntity entity = await CartQueryDao.fetch(token);
    if (entity?.goods != null) {
      int numTmp = 0;
      if (entity.goods.isNotEmpty) {
        // ignore: avoid_function_literals_in_foreach_calls
        entity.goods.forEach((GoodsModel el) {
          numTmp = numTmp + el.num;
        });

        ///更新總數
        setState(() {
          num = numTmp;
        });
      }
    } else {
      ToastUtil.buildToast('服務器錯誤');
    }
  }

  // ignore: avoid_void_async
  void clearUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
