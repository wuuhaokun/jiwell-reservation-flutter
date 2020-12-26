class CartEntity {
  CartModel  cartModel;

  // ignore: sort_constructors_first
  CartEntity({this.cartModel});
  // ignore: sort_constructors_first
  CartEntity.fromJson(Map<String, dynamic> json) {
    if (json['code'] != null) {
        cartModel =CartModel.fromJson(json);
    }
  }
}
class CartModel {
  String msg;
  int code;
  // ignore: sort_constructors_first
  CartModel({this.msg, this.code});
  // ignore: sort_constructors_first
  CartModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    code = int.parse(json['code'].toString());
  }
}
