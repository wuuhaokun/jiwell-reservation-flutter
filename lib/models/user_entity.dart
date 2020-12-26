class UserEntity {
	int statusCode = 200;
	UserInfoModel  userInfoModel;
	MsgModel msgModel;
	UserEntity({this.userInfoModel,this.msgModel});
	UserEntity.fromJson(Map<String, dynamic> json) {
		if (json['data'] != null) {
			if(json['data'].isNotEmpty){
				userInfoModel =new UserInfoModel.fromJson(json['data']);
			}else{
				msgModel=new MsgModel.fromJson(json);
			}
		}
	}
}
class UserInfoModel {
	String avatar;
	String mobile;
	String nickName;
	String id;
	String gender;
	Map<String, dynamic> jsonMap;


	UserInfoModel({this.avatar, this.mobile, this.nickName,this.gender});

	UserInfoModel.fromJson(Map<String, dynamic> json) {
		if(json['avatar'] != null){
			avatar = json['avatar'];
		}
		else{
			avatar = '';
		}

		if(json['mobile'] != null){
			mobile = json['mobile'];
		}
		else{
			mobile = json['phone'];
		}

		if(json['nickName'] != null){
			nickName = json['nickName'];
		}
		else{
			nickName = json['nickname'];
 		}

		if(json ['id'] != null) {
			if(json ['id'].runtimeType == int){
				id = json ['id'].toString();
			}
			else {
				id = json ['id'];
			}
		}

		if(json ['gender'] != null) {
			gender = json ['gender'];
		}
		jsonMap = json;
	}

}
class MsgModel{
	String msg;
	MsgModel({this.msg});
	MsgModel.fromJson(Map<String, dynamic> json){
		msg=json['msg'];
	}

}
