import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:jiwell_reservation/common.dart';

import 'package:jiwell_reservation/dao/add_goods_cart_dao.dart';
import 'package:jiwell_reservation/dao/add_like_dao.dart';
import 'package:jiwell_reservation/dao/cart_query_dao.dart';
import 'package:jiwell_reservation/dao/is_like_dao.dart';
import 'package:jiwell_reservation/dao/new/favorite_dao.dart';
import 'package:jiwell_reservation/models/cart_goods_query_entity.dart';
import 'package:jiwell_reservation/models/details_entity.dart';
import 'package:jiwell_reservation/models/msg_entity.dart';
import 'package:jiwell_reservation/models/msg_like_entity.dart';
import 'package:jiwell_reservation/models/new/specifications_entity.dart';
import 'package:jiwell_reservation/models/new/spus_entity.dart';
import 'package:jiwell_reservation/page/load_state_layout.dart';
import 'package:jiwell_reservation/page/new/specs_top_area.dart';
import 'package:jiwell_reservation/page/specifica_button.dart';

import 'package:jiwell_reservation/receiver/event_bus.dart';
import 'package:jiwell_reservation/res/colours.dart';
import 'package:jiwell_reservation/routes/routes.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/utils/dialog_utils.dart';
import 'package:jiwell_reservation/utils/image_utils.dart';
import 'package:jiwell_reservation/view/app_topbar.dart';
import 'package:jiwell_reservation/view/custom_view.dart';
import 'package:jiwell_reservation/view/customize_appbar.dart';
import 'package:jiwell_reservation/view/theme_ui.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rate_my_app/rate_my_app.dart';

import 'package:shared_preferences/shared_preferences.dart';

RateMyApp rateMyApp = RateMyApp(
  preferencesPrefix: 'rateMyApp_',
  minDays: 7,
  minLaunches: 10,
  remindDays: 7,
  remindLaunches: 10,
  googlePlayIdentifier: 'fr.skyost.example',
  appStoreIdentifier: '1491556149',
);

///
/// 商品詳情頁
///
class ProductSpec extends StatefulWidget {
  final String spusModelJson;
  const ProductSpec({this.spusModelJson});

  @override
  _ProductSpecState createState() => _ProductSpecState();
}

class _ProductSpecState extends State<ProductSpec>  {
  int num = 0;
  final String imgUrl =
      'http://linjiashop-mobile-api.microapp.store/file/getImgStream?idFile=';
  LoadState _loadStateDetails = LoadState.State_Loading;
  //GoodsModelDetail goodsModel;
  SkuModel skuModel;
  listModel model = listModel();
  StreamSubscription _spcSubscription;
  StreamSubscription _carSubscription;
  StreamSubscription _selectedSkuSubscription;
  StreamSubscription _toAddCarButtonSubscription;


  SpecificationsEntity _specificationsEntity;
  SpusModel _spusModel;
  WskuModel _wSkuModel;
  Map _ownSpec;
  @override
  void initState() {
    _listen();
    _init();
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
    _selectedSkuSubscription.cancel();
    _toAddCarButtonSubscription.cancel();
  }
  // ignore: avoid_void_async
  void loadLike() async{
    if(AppConfig.token.isNotEmpty) {
      final bool entityLike = await FavoriteDao.isFavoriteFetch(AppConfig.token,int.parse(AppConfig.userId),_spusModel.id);
      if (entityLike != null && entityLike == true) {
        setState(() {
          isLike = true;
        });

      } else {
        ToastUtil.buildToast('失敗');
        isLike = false;
      }
    }
  }

  ///
  /// 監聽Bus events
  void _listen() {
    _spcSubscription = eventBus.on<SpecEvent>().listen((SpecEvent event) {
      if (mounted && skuModel.listModels != null) {
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
        final Map<String, String> p = {'from': 'from_product_spec_to_car_page'};
        Routes.instance.navigateToParams(context, Routes.car_page, params: p);
      }
    });

    _toAddCarButtonSubscription = eventBus.on<ToAddCarButtonInEvent>().listen((ToAddCarButtonInEvent event) {
      if (mounted) {
        showBottomMenu();
      }
    });

    _selectedSkuSubscription = eventBus.on<SelectedSkuEvent>().listen((SelectedSkuEvent event) {
      if (mounted) {
        _wSkuModel = _spusModel.skuModelLists[event.index];
        _ownSpec = event.ownSpec;
      }
    });

  }
  bool isLike ;

  void _init(){
    _parseSpecifications();
  }

  void _parseSpecifications(){
    Map<String, dynamic> spusModelMap = jsonDecode(widget.spusModelJson);
    _spusModel =  SpusModel.fromJson(spusModelMap);
    String specifications = _spusModel.spuDetailModel.specifications;
    Map<String, dynamic> specificationsMap = jsonDecode(specifications);
    _specificationsEntity = SpecificationsEntity.fromJson(specificationsMap);
  }

  // ignore: avoid_void_async
  void loadData() async {
    if(mounted){
      if(_specificationsEntity != null){
        urls.clear();
        if (_spusModel.images != null && _spusModel.images.isNotEmpty) {
          if(_spusModel.images.contains(',')) {
            urls = _spusModel.images.split(',');
          }
          else{
            urls.add(_spusModel.images);
          }
          setState(() {
            _loadStateDetails = LoadState.State_Success;
          });
        }
      }
    }
    else{
      setState(() {
        _loadStateDetails = LoadState.State_Error;
      });
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
    if (null == _spusModel) {
      return CommonBackTopBar(
          title: '商品列表', onBack: () => Navigator.pop(context));
    } else {
      return CommonBackTopBar(
          title: _spusModel.title, onBack: () => Navigator.pop(context));
    }
  }
  List<ParamsModel> params = [];
  Widget _getBody() {

    return true
        ? Stack(
            children: <Widget>[
              ListView(
                children: _getSpecsListWidget(),
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

  List<Widget> _getSpecsListWidget(){

    for (WskuModel wSku in _spusModel.skuModelLists) {
      _wSkuModel = wSku;
      break;
    }

    List<Widget> list = [];
    _specificationsEntity.specificationsModelList.forEach((SpecificationsModel v) {
      //list.add(_goodsImage());
      list.add(Container(
        width: double.infinity,
        height: AppSize.height(94),
        child: Text(
          v.group,
          textAlign: TextAlign.center,
          style: ThemeTextStyle.personalShopNameStyle,
        ),
      ));
      list.add(SpecsTopArea(gallery: urls, params: v.params,skuModelLists:_spusModel.skuModelLists));
    });
    //list.add(Html(data: ));
    return list;
  }

  ///返回内容
  Widget _getContent() {
    if (_specificationsEntity == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return _getBody();
    }
  }

  ///商品圖片
  Widget _goodsImage(){
    return Container(
      height: AppSize.height(480),
      width: double.infinity,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: ImageUtils.getCachedNetworkImage("${urls[0]}",BoxFit.cover,null),
            // child: Image.network(
            //   imgUrl+"${urls[0]}",
            //   fit: BoxFit.cover,
            // ),
          );
        },
        itemCount: urls.length,
        pagination: SwiperPagination(margin: EdgeInsets.all(1.0)),
        autoplay: true,
      ),
    );

  }

  // ignore: avoid_void_async
  void addLike() async {
    if(AppConfig.token.isNotEmpty) {
      final bool entityLike = await FavoriteDao.saveFetch(AppConfig.token,int.parse(AppConfig.userId),_spusModel.id);
      if (entityLike != null && entityLike == true) {
        ToastUtil.buildToast('收藏成功');
        setState(() {
          isLike = true;
        });

      } else {
        ToastUtil.buildToast('收藏失敗');
        isLike = false;
      }
    }

    // final MsgEntity entity = await AddLikeDao.fetch(token, idGoods);
    // if (entity?.msgModel != null) {
    //   if (entity.msgModel.code == 20000) {
    //     ToastUtil.buildToast('收藏成功');
    //     setState(() {
    //       isLike = true;
    //     });
    //   }
    //
    // } else {
    //   ToastUtil.buildToast('收藏失敗');
    // }
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
                    final Map<String, String> p = {'index': 'from_product_spec_to_car_page'};
                    Routes.instance.navigateToParams(context, Routes.login_page, params: p);
                    return;
                  }
                  // ignore: always_specify_types
                  final Map<String, String> p = {'from': 'from_product_spec_to_car_page'};
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
              //試作五顆星評
              // _showStarRateDialog();
              // return;
              if(!isLike){
                if (AppConfig.token==null||AppConfig.token.isEmpty) {
                  Routes.instance.navigateTo(context, Routes.login_page);
                  return;
                }
                addLike();
              }
            },
    // child: Container(
    // padding: EdgeInsets.symmetric(horizontal: AppSize.width(30)),
    // child: IconBtn(Icons.star_border,text: '收藏',textStyle:
    // isLike?ThemeTextStyle.priceStyle: ThemeTextStyle.orderContentStyle,
    // iconColor: isLike?Colours.lable_clour:ThemeColor.subTextColor
    // ),

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
              String token = AppConfig.token;
              if (AppConfig.token==null||AppConfig.token.isEmpty) {
                final Map<String, String> p = {'index': 'from_product_spec_to_showBottomMenu'};
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
                final Map<String, String> p = {'index': 'from_product_spec_to_car_page'};
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
    EasyLoading.show(status: '添加中...');
    bool entity = await AddDao.fetch1(title,count,idSku,price,image,ownSpec,description,token);
    EasyLoading.dismiss();
    if(entity != null && entity == true) {
      setState(() {
        num++;
      });
      Navigator.pop(context);
      //ToastUtil.buildToast('加入成功');
      EasyLoading.showInfo('添加購物車成功');
      Timer(Duration(seconds:1), (){
        EasyLoading.dismiss();
      });
    }
    else{
      EasyLoading.showInfo('添加購物車失敗，請稍後在試');
      Timer(Duration(seconds:1), (){
       EasyLoading.dismiss();
      });
      //ToastUtil.buildToast('添加購物車失敗');
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
              height: (skuModel == null || skuModel.listModels == null || skuModel.listModels.isEmpty) ? 240.0 : 600.0,
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
                  (skuModel == null || skuModel.listModels == null || skuModel.listModels.length <= 0|| skuModel.listModels.isEmpty) ? Container() : Expanded(
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
                                addCart(_wSkuModel.title, 1,_wSkuModel.id.toString() ,_wSkuModel.price.toDouble() ,_wSkuModel.images,_ownSpec.toString(),_wSkuModel.description, AppConfig.token);
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
    List<String> lists = [];
    _specificationsEntity.specificationsModelList.forEach((SpecificationsModel v) {
      v.params.forEach((paramsModel) {
        //if(paramsModel.global == true){
          lists.add(paramsModel.k);
        //}
      });
    });

    return (skuModel == null || skuModel.listModels == null || skuModel.listModels.length <= 0|| skuModel.listModels.isEmpty)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _ownSpecWidget(lists)
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_wSkuModel.title,
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

  List<Widget> _ownSpecWidget(List<String> lists) {

    List<Widget> widgetList = [];

    widgetList.add( Text(_wSkuModel.title,
        maxLines: 2,
        overflow: TextOverflow.clip,
        style: ThemeTextStyle.primaryStyle));

    widgetList.add(Text.rich(TextSpan(
        text: 'NT' + _wSkuModel.price.toString() + '元',
        style: ThemeTextStyle.cardPriceStyle,
        children: [
          TextSpan(text: '+', style: descTextStyle1),
          const TextSpan(text: '60'),
          TextSpan(text: '積分', style: descTextStyle1)
        ])));

    lists.forEach((key) {
      String value = _ownSpec[key];
      if(value != '') {
        widgetList.add(Text(key + ':' + value,
            maxLines: 2,
            overflow: TextOverflow.clip,
            style: descTextStyle1));
      }
    });
    widgetList.add(Text('庫存:' + _wSkuModel.stock.toString(), style: descTextStyle1));
    return widgetList;
  }

  void _showStarRateDialog(){
    rateMyApp.showStarRateDialog(
      context,
      title: '為這個產品評分', // The dialog title.
      message: '你喜歡這個產品嗎？ 請花一點時間來給評分：', // The dialog message.
      // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
      actionsBuilder: (context, stars) { // Triggered when the user updates the star rating.
        return [ // Return a list of actions (that will be shown at the bottom of the dialog).
          FlatButton(
            child: Text('是'),
            onPressed: () async {
              print('Thanks for the ' + (stars == null ? '0' : stars.round().toString()) + ' star(s) !');
              // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
              // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
              await rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
              Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.rate);
            },
          ),
        ];
      },
      ignoreNativeDialog: Platform.isIOS, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
      dialogStyle: DialogStyle( // Custom dialog styles.
        titleAlign: TextAlign.center,
        messageAlign: TextAlign.center,
        messagePadding: EdgeInsets.only(bottom: 20),
      ),
      starRatingOptions: StarRatingOptions(), // Custom star bar rating options.
      onDismissed: (){
        rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed);
        }, // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
    );
  }
}
