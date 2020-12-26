import 'dart:math';

/// 商品详情页面
class DetailsEntity {
	GoodsModelAndSku goods;
// ignore: sort_constructors_first
	DetailsEntity({this.goods});
// ignore: sort_constructors_first
	DetailsEntity.fromJson(Map<String, dynamic> json) {
		if (json['data'] != null) {
			//
			//if(json['data']['skus'] !=null) {
			//	goods = GoodsModelAndSku.fromJson(
			//			json['data'], json['data']['skus']);
			//}else{
// ignore: always_specify_types
			  final Map<String,dynamic>map = {'skus':json['data']};

				goods = GoodsModelAndSku.fromJson(
						json['data'], map);
			//}
		}
	}
}
class GoodsModelAndSku{
	GoodsModelDetail goodsModelDetail;
	SkuModel skuModel;
// ignore: sort_constructors_first
	GoodsModelAndSku({this.goodsModelDetail,this.skuModel});
// ignore: sort_constructors_first
	GoodsModelAndSku.fromJson(Map<String, dynamic> jsonGoods,Map<String, dynamic> jsonSku){
		goodsModelDetail =GoodsModelDetail.fromJson(jsonGoods);
		if(null==jsonSku){
			skuModel=null;
		}else {
			skuModel = SkuModel.fromJson(jsonSku);
		}
	}

}
class SkuModel{
  // ignore: non_constant_identifier_names
  bool hide_stock;
  // ignore: non_constant_identifier_names
  bool none_sku;
  int price;
	List<TreeModel> treeModel;
	List<listModel> listModels;
// ignore: sort_constructors_first, non_constant_identifier_names
	SkuModel({this.hide_stock,this.none_sku,this.price,this.treeModel,this.listModels});
// ignore: sort_constructors_first
	SkuModel.fromJson(Map<String, dynamic> json){
		if(json['hide_stock'] != null) {
			hide_stock = json['hide_stock'];
		}
		else{
			hide_stock = false;
		}

		if(json['none_sku'] != null) {
			none_sku = json['none_sku'];
		}
		else{
			none_sku = false;
		}

		if(json['price'].toString().isEmpty){
			price=0;
		}else {
			price = json['price'];
			final int hh =  json['price'];
			print(hh);
		}

//		List<Map> dataListTree= (json['tree'] as List).cast();
//		treeModel = List<TreeModel>();
//		listModels = List<listModel>();
//
//		dataListTree.forEach((t) {
//			treeModel.add(TreeModel.fromJson(t));
//		});
		if(json['list'] != null) {
// ignore: avoid_as, always_specify_types
			final List<Map> dataListTreeList = (json['list'] as List).cast();
// ignore: always_specify_types, avoid_function_literals_in_foreach_calls
			dataListTreeList.forEach((Map l) {
				listModels.add(listModel.fromJson(l, treeModel));
			});
		}
	}
}
class TreeModel{
// ignore: non_constant_identifier_names
	String k_s;
	String k;
	List<vModel> vModels;

// ignore: sort_constructors_first, non_constant_identifier_names
	TreeModel({this.k,this.k_s,this.vModels});
// ignore: sort_constructors_first
	TreeModel.fromJson(Map<String, dynamic> json){
		k_s=json['k_s'];
		k= json['k'];
// ignore: avoid_as, always_specify_types
		final List<Map> dataList= (json['v'] as List).cast();
		vModels=<vModel>[];
// ignore: always_specify_types, avoid_function_literals_in_foreach_calls
		dataList.forEach((Map v) {
			vModels.add(vModel.fromJson(v));
		});
	}

}
// ignore: camel_case_types
class vModel{
	String id;
	String name;
// ignore: sort_constructors_first
	vModel({this.id,this.name});
// ignore: sort_constructors_first
	vModel.fromJson(Map<String, dynamic> json){
		id = json['id'];

		name=json['name'];
	}
}
// ignore: camel_case_types
class listModel{
//	"price": 69900,
//	"id": "1",
//	"s1": "1",
//	"s2": "3",
//	"stock_num": 100
//	"code": "1,3",
   int price;
   String id;
   // ignore: non_constant_identifier_names
   int stock_num;
   String code;
   Map<String,String> map;
// ignore: sort_constructors_first, non_constant_identifier_names
	 listModel({this.price,this.id,this.stock_num,this.map,this.code});
// ignore: sort_constructors_first
	 listModel.fromJson(Map<String, dynamic> json,List<TreeModel> trModel){
	 	 id = json['id'];
		 if(json['price'].toString().isEmpty){
		 	price = 0;
		 }else {
			 price = int.parse(json['price'].toString());
		 }
		 if(json['stock_num'].toString().isEmpty){
			 stock_num = 0;
	 	 }else {
			 stock_num = int.parse(json['stock_num'].toString());
		 }
		 code = json['code'];

		 map=<String,String>{};
// ignore: avoid_function_literals_in_foreach_calls
		 trModel.forEach((TreeModel e){
			 map[e.k_s] = json[e.k_s];
		 });

	 }

}



class GoodsModelDetail {
	String createBy;
	String createTime;
	String descript;
	String gallery;
	String detail;
	String idCategory;
	String id;
	bool isDelete;
	bool isOnSale;
	String modifyBy;
	String modifyTime;
	String name;
	int  num;
	String pic;
	int price;
	String specifications;


// ignore: sort_constructors_first
	GoodsModelDetail({this.createBy, this.createTime, this.descript, this.detail,
		this.idCategory,this.isDelete,this.isOnSale,this.modifyBy,this.modifyTime,
		this.name,this.num,this.pic,this.price,this.specifications,this.id,this.gallery});

// ignore: sort_constructors_first
	GoodsModelDetail.fromJson(Map<String, dynamic> json) {

    if(json['createBy'] != null){
			createBy = json['createBy'];
		}
    else{
			createBy = '1';
		}
		if(json['createTime'] != null){
			createTime = json['createTime'];
		}

		if(json['descript'] != null){
			descript = json['descript'];
		}
		else{
			descript = '';//json['subTitle'];
		}

		if(json['detail'] != null){
			detail = json['detail'];
		}
		else{
			//detail = json['spuDetail']['description'];
			detail ='';//json['subTitle'];
		}

		if(json['idCategory'] != null){
			idCategory = json['idCategory'];
		}
		else{
			//idCategory = json['cid3'].toString();
			idCategory = '-1';
		}

		if(json['isDelete'] != null){
			isDelete = json['isDelete'];
		}
		else{
			isDelete = json['enable'];
		}

		if(json['isOnSale'] != null){
			isOnSale = json['isOnSale'];
		}
		else{
			isOnSale = json['enable'];
		}

		if(json['modifyBy'] != null){
			modifyBy = json['modifyBy'];
		}
		else {
			modifyBy = '1';
		}

		if(json['modifyTime'] != null){
			modifyTime=json['modifyTime'];
		}
		else{
			modifyTime=json['lastUpdateTime'];
		}

		if(json['name'] != null) {
			name = json['name'];
		}
		else{
			name = json['title'];
		}

		if(json['stock'] != null) {
			if (json['stock']
					.toString()
					.isEmpty) {
				num = 0;
			} else {
				num = int.parse(json['stock'].toString());
			}
		}
		else{
			num = 110;
		}

		if(json['pic'] != null) {
			pic = json['pic'];
		}
		else{
			pic = json['images'];
		}

		if(json['price'] != null) {
			if (json['price']
					.toString()
					.isEmpty) {
				price = 0;
			} else {
				price = int.parse(json['price'].toString());
			}
		}
		else{
			price = 999;
		}

		if(json['specifications'] != null){
			specifications = json['specifications'];
		}else{
			//specifications = json['spuDetail']['specifications'];
			specifications = json['ownSpec'];
		}
		if(json['id']!= null) {
			if(json['id'].runtimeType == int) {
				id = json['id'].toString();
			}
			else{
				id = json['id'];
			}
		}
		if(json['gallery'] != null) {
			gallery = json['gallery'];
		}
		else{
			gallery = 'b1b53d00-e7c7-460e-b953-64ac2a05768c.jpg,65a7d4f0-fa1e-49b0-bc6e-517f0c0d5b9a.jpg';
		}
	}


}
