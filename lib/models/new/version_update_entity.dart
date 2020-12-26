
import 'dart:convert';

class VersionUpdateEntity {

	VersionUpdateModel versionUpdateModel;
	VersionUpdateEntity({this.versionUpdateModel});
	VersionUpdateEntity.fromJson(Map<String, dynamic> json) {
  	if (json != null) {
			versionUpdateModel = VersionUpdateModel.fromJson(json);
		}
	}

}

class VersionUpdateModel {
	String iosVersion;
	String androidVersion;
	String content;
	String force_update;
	String androidAppId;
	String iOSAppId;

	VersionUpdateModel({this.iosVersion,this.androidVersion,this.content,
	this.force_update,this.androidAppId,this.iOSAppId});

	VersionUpdateModel.fromJson(Map<String, dynamic> json) {
		iosVersion = json["ios_version"];
		androidVersion = json["android_version"];
		content = json["content"];
		force_update= json["force_update"];
		androidAppId = json["androidAppId"];
		iOSAppId = json["iOSAppId"];
	}

}
