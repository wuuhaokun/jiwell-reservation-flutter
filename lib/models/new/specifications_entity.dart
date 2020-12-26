

import 'package:jiwell_reservation/generated/i18n.dart';
import 'package:jiwell_reservation/models/goods_entity.dart';


//{"specifications":[{"group":"主体","params":[{"k":"大小選擇","searchable":false,"global":true,"options":[{"name":"大","price":"10"},{"name":"中","price":"0"}]},{"k":"冰熱選擇","searchable":false,"global":true,"options":[{"name":"正常冰","price":"0"},{
class SpecificationsEntity {
  //String group;
  List<SpecificationsModel> specificationsModelList = [];

  SpecificationsEntity({this.specificationsModelList});
  SpecificationsEntity.fromJson(Map<String, dynamic> json) {
    if (json['specifications'] != null) {
      var list = json['specifications'];
      specificationsModelList.add(SpecificationsModel.fromJson(list[0]));
    }
  }
}

class SpecificationsModel {
  String group;
  List<ParamsModel> params = [];
  SpecificationsModel({this.group,this.params});
  SpecificationsModel.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      group = (json['group']??'');
      var paramList = json['params'];
      paramList.forEach((v) {
        params.add(new ParamsModel.fromJson(v));
      });
    }
  }
}

class ParamsModel {
  String k;
  bool searchable;
  bool global;
  List<OptionsModel>options = [];
  List<OptionsModel>multipleOptions = [];

  ParamsModel({this.k,this.searchable,this.global,this.options});
  ParamsModel.fromJson(Map<String, dynamic> data) {
    k = (data['k']??'');
    searchable = (data['searchable']??false);
    global = (data['global']??false);

    if(data['options'] != null) {
      List<Map> optionList = (data['options'] as List).cast();
      optionList.forEach((v) {
        options.add(new OptionsModel.fromJson(v));
      });
    }
    if(data['multiple_options'] != null) {
      List<Map> multipleOptionList = (data['multiple_options'] as List).cast();
      multipleOptionList.forEach((v) {
        multipleOptions.add(new OptionsModel.fromJson(v));
      });
    }

  }
}

class OptionsModel {
  String name;
  String price;
  OptionsModel({this.name,this.price});
  OptionsModel.fromJson(Map<String, dynamic> data) {
    name = (data['name']??'');
    price = (data['price']??'-1');
  }
}
