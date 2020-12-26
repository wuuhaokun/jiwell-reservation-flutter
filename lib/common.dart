import 'dart:async';

import 'package:jiwell_reservation/utils/fcm_push.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dao/new/jwfirebase_dao.dart';
import 'dao/user_dao.dart';
import 'models/user_entity.dart';

enum HomeData{
  topic,
  cateGory
}

// ignore: avoid_classes_with_only_static_members
class AppConfig {
  static  bool isCanUsing = true;
  static  bool isUser = false;
  static int orderIndex=0;
  static String token='';
  static String  gender='';
  static String avatar='';
  static String mobile='';
  static String nickName='';
  static String userId='';
  static String firebaseToken ='';

  static loadUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences
        .getInstance();
    AppConfig.token = prefs.getString('token');
    if(AppConfig.token == null || AppConfig.token.isEmpty){
      return;
    }
    final UserEntity entity = await UserDao.fetch(AppConfig.token);
    if (entity?.userInfoModel != null && entity.statusCode == 200) {
      AppConfig.isCanUsing = true;
      AppConfig.nickName=entity.userInfoModel.nickName;
      AppConfig.mobile=entity.userInfoModel.mobile;
      AppConfig.avatar=entity.userInfoModel.avatar;
      AppConfig.gender=entity.userInfoModel.gender;
      AppConfig.userId=entity.userInfoModel.id;
    }
    else if(entity?.userInfoModel != null && entity.statusCode == 403){
      clearUserInfo();
      // prefs.clear();
      // AppConfig.token = '';
      // AppConfig.nickName=entity.userInfoModel.nickName;
      // AppConfig.mobile=entity.userInfoModel.mobile;
      // AppConfig.avatar=entity.userInfoModel.avatar;
      // AppConfig.gender=entity.userInfoModel.gender;
      // AppConfig.userId=entity.userInfoModel.id;
    }
    else if(entity!= null && entity.statusCode == 500) {
      AppConfig.isCanUsing = false;
    }
    else if(entity == null || entity?.userInfoModel == null){
      AppConfig.isCanUsing = false;
    }

  }

  static void clearUserInfo() async {
    AppConfig.token='';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', '');

    AppConfig.isUser = false;
    AppConfig.orderIndex=0;
    AppConfig.token='';
    AppConfig.gender='';
    AppConfig.avatar='';
    AppConfig.mobile='';
    AppConfig.nickName='';
    AppConfig.userId='';
    AppConfig.firebaseToken ='';
    AppConfig.isCanUsing = true;
  }

  static Future<bool>registerFirebaseToken() async {
    final SharedPreferences prefs = await SharedPreferences
        .getInstance();
    int userId = int.parse(AppConfig.userId);
    JwfirebaseDao.fetch(userId,FcmNotification.getInstance().fcmToken);
  }


}

//使用請參考 Flutter中的节流与防抖 https://www.jianshu.com/p/2b70ef340e82
Function throttle(Future Function() func){
  if (func == null) {
    return func;
  }
  bool enable = true;
  Function target = () {
    if (enable == true) {
      func().then((_) {enable = false;});
      Future.delayed(Duration(milliseconds: 5000),()=>enable = true);
    }
  };
  return target;
}

// Function debounce( //這程式有問題的
//     Function func, [
//       Duration delay = const Duration(milliseconds: 2000),
//     ]) {
//   Timer timer;
//   Function target = () {
//     if (timer?.isActive ?? false) {
//       timer?.cancel();
//     }
//     timer = Timer(delay, () {
//       func?.call();
//     });
//   };
//   return target;
// }