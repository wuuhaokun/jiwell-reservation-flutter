import 'cart_goods_query_entity.dart';

import 'cart_goods_query_entity.dart';

class OrderEntity {
  List<OrderModel>   orderModel;
  OrderEntity({this.orderModel});
  OrderEntity.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      orderModel = <OrderModel>[];
      (json['data']['items'] as List).forEach((v) {
        orderModel.add(OrderModel.fromJson(v));
      });
    }
  }
}
class OrderModel {

  String orderId;
  int actualPay;
  int totalPay;
  String statusName;
  int status;
  List<GoodsModel> goods;
  OrderModel({this.orderId, this.actualPay,this.totalPay,this.statusName,
    this.status,this.goods});
  OrderModel.fromJson(Map<String, dynamic> json) {
    orderId = (json['orderId']??'-1');
    totalPay = (json['totalPay'].toInt()??0);
    actualPay = (json['actualPay'].toInt()??0);
    //statusName = (json['statusName']??'未知');
    status = (json['status']??1);
    //'状态：1、未付款 2、已付款,未发货 3、已发货,未确认 4、交易成功 5、交易关闭 6、已评价'
    if(status == 1){
      statusName = '未付款';
    }
    else if(status == 2){
      statusName = '已付款，未發貨';
    }
    else if(status == 3){
      statusName = '已發貨，未確認';
    }
    else if(status == 4){
      statusName = '交易成功';
    }
    else if(status == 5){
      statusName = '交易關閉';
    }
    else if(status == 6){
      statusName = '己評價';
    }
    goods=<GoodsModel>[];
    (json['orderDetails'] as List).forEach((v) {
      goods.add(GoodsModel.fromJson(v));
    });

  }

}
