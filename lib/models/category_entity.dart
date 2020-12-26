
class CategoryEntity {
	List<CategoryModel> category;
// ignore: sort_constructors_first
	CategoryEntity({this.category});
// ignore: sort_constructors_first
	CategoryEntity.fromJson(Map<String, dynamic> json) {
		if (json['data'] != null) {
// ignore: avoid_as, avoid_function_literals_in_foreach_calls, always_specify_types
			category = <CategoryModel>[];(json['data'] as List).forEach((v) {
				category.add(CategoryModel.fromJson(v)); });
		}
	}
}

class CategoryModel{

	String name;
	String id;
	List<CategoryInfoModel> categoryInfoModels;
	
// ignore: sort_constructors_first
	CategoryModel({this.name,this.id, this.categoryInfoModels});
// ignore: sort_constructors_first
	factory CategoryModel.fromJson(Map<String, dynamic> parsedJson){
		//Map<String,dynamic> bannerList = {'bannerList':[{'createTime':'2019-03-09 16:29:03','id':'1','idFile':'75b1e658-161e-4b12-83b0-abd2c1bead39.jpg','modifyBy':'','modifyTime':'','page':'goods','param':'{\"id\":2}','title'":'红米Rote8,打开外部链接','type':'index','url':''}]};
		//String bannerList = [{'createTime':'2019-03-09 16:29:03','id':'1','idFile':'75b1e658-161e-4b12-83b0-abd2c1bead39.jpg','modifyBy':'','modifyTime':'','page':'goods','param':'{\"id\":2}','title':'红米Rote8,打开外部链接','type':'index','url':''}];
// ignore: always_specify_types
		final Map<String,dynamic> bannerList = {'bannerList':[{'createTime':'2019-03-09 16:29:03','id':'1','idFile':'75b1e658-161e-4b12-83b0-abd2c1bead39.jpg','modifyBy':'','page':'goods','param':'{\"id\":2}','title':'红米Rote8,打开外部链接','type':'index','url':''}]};

// ignore: avoid_as, always_specify_types
		final List list = bannerList['bannerList'] as List;
		final List<CategoryInfoModel> categoryInfoList = list.map((i) => CategoryInfoModel.fromJson(i)).toList();
		
		return CategoryModel(
				id: (parsedJson['id']).toString(),
				name: parsedJson['name'],
				categoryInfoModels: categoryInfoList
		);
	}
}

class CategoryInfoModel {
	String createBy;
	String createTime;
	String image;
	String modifyBy;
	String modifyTime;
	String title;
	String type;
	String url;
	int id;
	String page;
	String param;

// ignore: sort_constructors_first
	CategoryInfoModel({this.createBy, this.createTime, this.image, this.modifyBy,
		this.modifyTime,this.title,this.type,this.url,this.id,this.page});

// ignore: sort_constructors_first
	CategoryInfoModel.fromJson(Map<String, dynamic> json) {
		createBy = (json['createBy']??'');
		createTime = (json['createTime']??'');
		image = (json['image'])??'';
		modifyBy = (json['modifyBy']??'');
		modifyTime = (json['modifyTime']??'');
		title = (json['title']??'');
		type = (json['type']??'');
		url = (json['url']??'');
		id = (json['id']??-1);
		page = (json['page']??'');
		param = (json['param'])??'';
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['createBy'] = (createBy??'');
		data['createTime'] = (createTime??'');
		data['image'] = (image??'');
		data['modifyBy'] = (modifyBy??'');
		data['modifyTime'] = (modifyTime??'');
		data['title'] = (title??'');
		data['type'] = (type??'');
		data['url'] = (url??'');
		data['id'] = (id??-1);
		data['page'] = (page??'');
		return data;
	}
}
