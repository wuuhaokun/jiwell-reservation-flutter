class ShippingAddresEntry {
  List<ShippingAddressModel> shippingAddressModels;
  ShippingAddresEntry({this.shippingAddressModels});

  ShippingAddresEntry.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      shippingAddressModels = new List<ShippingAddressModel>();
      (json['data'] as List).forEach((v) {
        shippingAddressModels.add(new ShippingAddressModel.fromJson(v));
      });
    }
  }
}


class ShippingAddressModel {
  String id;
  String userId;
  String name;
  String phone;
  String zipCode;//郵政區號
  String address;//詳細地址
  String district;//區
  String state;//省
  String city;//市
  bool defaultAddress;//是否為預設地址
  String label;//地址標籤

  ShippingAddressModel({this.id, this.userId,this.name,this.phone,
    this.zipCode,this.address,this.district,this.state,this.city,
    this.defaultAddress,this.label});
  ShippingAddressModel.fromJson(Map<String, dynamic> json) {
    address =(json['address']??'');
    zipCode =(json['zipCode']??'');
    district =(json['district']??'');
    name =(json['name']??'');
    state =(json['state']??'');
    phone =(json['phone']??'');
    id =(json['id']??'');
    city =(json['city']??'');
    defaultAddress =(json['defaultAddress']??false);
    userId = (json['userId']??'');
    label = (json['label']?? '');
  }
}