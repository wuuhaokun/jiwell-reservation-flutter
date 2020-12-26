import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:jiwell_reservation/page/cart_page.dart';
import 'package:jiwell_reservation/page/comment/comment_page.dart';
import 'package:jiwell_reservation/page/details/order_details.dart';
import 'package:jiwell_reservation/page/details/product_details.dart';
import 'package:jiwell_reservation/page/details/topic_details.dart';
import 'package:jiwell_reservation/page/goodsmanger/shipping_address.dart';
import 'package:jiwell_reservation/page/goodsmanger/shipping_edit_address.dart';
import 'package:jiwell_reservation/page/goodsmanger/shipping_save_address.dart';
import 'package:jiwell_reservation/page/like_goods_page.dart';
import 'package:jiwell_reservation/page/modify_name_page.dart';
import 'package:jiwell_reservation/page/modify_pwd_page.dart';
import 'package:jiwell_reservation/page/new/coupon_page.dart';
import 'package:jiwell_reservation/page/new/product_spec.dart';
import 'package:jiwell_reservation/page/orderform_page.dart';
import 'package:jiwell_reservation/page/pay/pay_page.dart';
import 'package:jiwell_reservation/page/reg_and_login.dart';
import 'package:jiwell_reservation/page/setting_page.dart';
import 'package:jiwell_reservation/page/web_page.dart';
import 'package:jiwell_reservation/page/product_items_page.dart';
class Routes {
  static final router = FluroRouter();
  static const ROOT = '/';
  // details
  static const ORDER_DETAILS = '/order_details';
  static const PRODUCT_DETAILS = '/product_details';

  static const product_items_page = '/product_items_page';
  static const car_page = '/car_page';
  static const login_page = '/login_page';
  static const order_page = '/order_page';
  static const pay_page = '/pay_page';
  static const address_page = '/address_page';
  static const save_address_page = '/save_address_page';
  static const new_address_page = '/new_address_page';
  static const web_page = '/web';
  static const topic_page = '/topic';
  static const setting_page = '/setting';
  static const modify_name_page = '/modify_name';
  static const modify_pwd_page = '/modify_pwd';
  static const Product_Spec_page = '/Product_Spec';
  static const like_goods_page = '/like_goods';
  static const star_rating_bar_widget = '/ratingbar';
  static const coupon_page = '/coupon_page';
  static const comment_page = '/CommentPage';
  static const use_coupon_page = '/use_coupon_page';


  void _config() {
    //router.define(ROOT, handler: Handler(handlerFunc: (context, params) => IndexPage()));

    router.define(
        PRODUCT_DETAILS, handler:
    Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) => ProductDetails(id:params['id'].first)));
    router.define(
        ORDER_DETAILS, handler:
    Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) => OrderDetails(orderSn:params['orderSn'].first)));
    router.define(
        pay_page, handler:
    Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        PayPage(orderSn:params['orderSn'].first,totalPrice:params['totalPrice'].first)));
    router.define(
        // ignore: unnecessary_parenthesis
        login_page, handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) => RegPageAndLoginPage(index:(params.isNotEmpty?params['index'].first:{'index':'-1'}))));
    router.define(
        order_page, handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) => OrderFormPage()));
    router.define(
        address_page, handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) => ShippingAddressPage()));
    router.define(
        // ignore: unnecessary_parenthesis, avoid_as
        save_address_page, handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) => ShippingEditAddressPage(id:params['id'].first,index:(params['index'].first))));
    router.define(
        web_page, handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) => WebViewPage(url:params['url'].first)));
    router.define(
        topic_page, handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) => TopicDetails(id:params['id'].first)));
    router.define(
        setting_page, handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) => SettingPage(index:(params.isNotEmpty?params['index'].first:{'index':'0'}))));
    router.define(
        modify_name_page, handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) => ModifyNamePage(name: params['name'].first,)));
    router.define(
        new_address_page, handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        ShippingSaveAddressPage()));
    router.define(
        modify_pwd_page, handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
    ModifyPwdPage()));
    router.define(
        product_items_page, handler:
    Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) => ProductItemsPage(id:params['id'].first,incategory:params['incategory'].first)));
    router.define(
        car_page, handler:
    Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) => CartPage(from:params['from'].first)));
    router.define(
        Product_Spec_page, handler:
    Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) => ProductSpec(spusModelJson:params['spusModelJson'].first)));

    // router.define(
    //     Product_Spec_page, handler:
    // Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) => ProductSpec(id:params['id'].first,specTemplate:params['specTemplate'].first,specifications:params['specifications'].first)));

    router.define(
        like_goods_page, handler: Handler(handlerFunc: (context, params) =>
        LikePage()));

    router.define(
        coupon_page, handler: Handler(handlerFunc: (context, params) =>
        CouponPage()));

    router.define(
        comment_page, handler: Handler(handlerFunc: (context, params) =>
        CommentPage()));

    router.define(
        use_coupon_page, handler: Handler(handlerFunc: (context, params) =>
        CouponPage()));


    // router.define(
    //     comment_page, handler:
    // Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) => CommentPage(themeId:params['themeId'].first)));

  }

  /**
   * 传递多参数
   */
  Future navigateToParams(BuildContext context, String path, {Map<String, dynamic> params}) {
    String query =  '';
    if (params != null) {
      int index = 0;
      for (String key in params.keys) {
        final String value = Uri.encodeComponent(params[key]);
        if (index == 0) {
          query = '?';
        } else {
          query = query + '\&';
        }
        query += '$key=$value';
        index++;
      }
    }
//    print('我是navigateTo传递的参数：$query');
    path = path + query;
    return router.navigateTo(context, path, transition: TransitionType.inFromRight);
  }


  // ignore: always_specify_types
  Future navigateTo(BuildContext context, String path){
    return router.navigateTo(context,path,transition: TransitionType.inFromRight);
  }

  // ignore: always_specify_types
  Future navigateToReplace(BuildContext context, String path,{Map<String, dynamic> params}){
    String query =  '';
    if (params != null) {
      int index = 0;
      for (String key in params.keys) {
        final String value = Uri.encodeComponent(params[key]);
        if (index == 0) {
          query = '?';
        } else {
          query = query + '\&';
        }
        query += '$key=$value';
        index++;
      }
    }
//    print('我是navigateTo传递的参数：$query');
    path = path + query;
    return router.navigateTo(context,path,replace: true,transition: TransitionType.inFromRight);
  }

  Future navigateFromBottom(BuildContext context, String path,[String param='']){
    var p = param.isNotEmpty?'$path/$param':path;
    return router.navigateTo(context,p,transition: TransitionType.inFromBottom);
  }

  // ignore: sort_constructors_first
  factory Routes() =>_getInstance();
  static Routes get instance => _getInstance();
  static Routes _instance;

  // ignore: sort_constructors_first
  Routes._internal() {
    _config();
  }
  static Routes _getInstance() {
    _instance ??= Routes._internal();
    return _instance;
  }
}
