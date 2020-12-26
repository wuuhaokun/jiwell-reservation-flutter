

class CartGoodsQueryEntity {
	List<GoodsModel> goods;

	CartGoodsQueryEntity({this.goods});

	CartGoodsQueryEntity.fromJson(Map<String, dynamic> json) {
		if (json['data'] != null) {
			goods = <GoodsModel>[];
			(json['data'] as List).forEach((v) {
				goods.add(GoodsModel.fromJson(v));
			}
			);
		}
	}

}

// class GoodsListModel {
// 	GoodsModel goodsModel;
// 	GoodsListModel({this.goodsModel/*,this.orderId,this.idGoods*/});
// 	GoodsListModel.fromJson(Map<String, dynamic> json){
// 		Map<String,dynamic> map =json;
// 		goodsModel = GoodsModel.fromJson(map/*,orderId,idGoods*/);
// 	}
// }

class GoodsModel {
	String userId;
	String title;
	String skuId;
	int  num;
	String image;
	int price;
	String ownSpec;
	String description;
	///客戶端自定義是否選中
	bool isCheck;
	int countNum;

	GoodsModel({ this.title,this.num,this.image,this.price,this.ownSpec,this.description,this.userId,this.skuId});
	GoodsModel.fromJson(Map<String, dynamic> json/*,String orderId,String idGoods*/) {
		description = (json['description']??'');
		title = (json['title']??'');
		if(json['stock'] != null) {
			if (json['stock']
					.toString()
					.isEmpty) {
				num = 0;
			} else {
				num = 0;//json['stock'];
			}
		}
		else{
			num = 0;//199;
		}
		num = (json['num']??0);
		image = (json['image']??'');
		if(json['price'] != null) {
			if(json['price'].runtimeType == double) {
				price = (json['price']).toInt();
			}
			else{
				price = json['price'];
			}
		}
		if(json['ownSpec'] != null) {
			ownSpec = json['ownSpec'];
		}
		else{
			ownSpec = json['ownSpec'];
		}
		userId = (json['userId']??-1).toString();
		countNum = (json['num']??0);
		skuId = (json['skuId']??0).toString();
		isCheck = true;
	}

}
