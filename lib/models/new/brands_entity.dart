
class BrandsEntity {
  List<BrandsModel> brandsModelList;
  List<BrandsModel> hotList;
  List<BrandsModel> newList;

  BrandsEntity({this.brandsModelList});
  BrandsEntity.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      brandsModelList = new List<BrandsModel>();
      hotList = new List<BrandsModel>();
      newList = new List<BrandsModel>();

      List<Map> dataList= (json['data'] as List).cast();
      dataList.forEach((v) {
        BrandsModel brandsModel = new BrandsModel.fromJson(v);
        brandsModelList.add(brandsModel);
        if(brandsModel.newbrand == true){
          newList.add(brandsModel);
        }
        if(brandsModel.hotbrand == true){
          hotList.add(brandsModel);
        }
      }
      );
    }
  }
}

class BrandsModel {
  int id;
  String name;
  String image;
  String title;
  String letter;
  String incategory;
  bool newbrand;
  bool hotbrand;

  BrandsModel({this.id,this.name,this.image,this.title,this.letter,this.incategory,this.newbrand,this.hotbrand});
  BrandsModel.fromJson(Map<String, dynamic> data) {
    id = (data['id']??-1);
    name = (data['name']??'');
    title = (data['title']??'');
    image = (data['image']??'');
    letter = (data['letter']??'');
    incategory = (data['incategory']??'');
    newbrand = (data['newbrand']??false);
    hotbrand = (data['hotbrand']??false);
  }
}