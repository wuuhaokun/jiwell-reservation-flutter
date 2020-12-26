class LoginEntity {
	UserModel  userModel;
	MsgModel msgModel;
	LoginEntity({this.userModel,this.msgModel});
	LoginEntity.fromJson(Map<String, dynamic> json) {
		//if (json['data'] != null) {
		//	if(json['data'].isNotEmpty){
		//		userModel =new UserModel.fromJson(json['data']);
		//	}else{
		//		msgModel=new MsgModel.fromJson(json);
		//	}
		//}
		if (json != null) {
			if(json.isNotEmpty){
				userModel =new UserModel.fromJson(json);
			}else{
				msgModel=new MsgModel.fromJson(json);
			}
		}
	}
}
class UserModel {

	String token;
	String registerState;
	UserModel({ this.token,this.registerState});

	UserModel.fromJson(Map<String, dynamic> json) {
		token = (json['token']??'');
		registerState = (json['registerState']??'');
	}

}
class MsgModel{
	String msg;
	MsgModel({this.msg});
	MsgModel.fromJson(Map<String, dynamic> json){
		msg=json['msg'];
	}
}
