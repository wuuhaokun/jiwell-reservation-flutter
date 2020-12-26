import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiwell_reservation/dao/login_dao.dart';
import 'package:jiwell_reservation/dao/login_reg_dao.dart';
import 'package:jiwell_reservation/dao/user_dao.dart';
import 'package:jiwell_reservation/models/login_entity.dart';
import 'package:jiwell_reservation/models/user_entity.dart';
import 'package:jiwell_reservation/page/reset_pwd_page.dart';

import 'package:jiwell_reservation/receiver/event_bus.dart';
import 'package:jiwell_reservation/routes/routes.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/utils/dialog_utils.dart';
import 'package:jiwell_reservation/view/app_topbar.dart';
import 'package:jiwell_reservation/view/customize_appbar.dart';
import 'package:jiwell_reservation/view/flutter_iconfont.dart';
import 'package:jiwell_reservation/view/theme_ui.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../common.dart';


// ignore: must_be_immutable
class RegPageAndLoginPage extends StatefulWidget {
  String index = '-1';

  RegPageAndLoginPage({this.index});

  @override
  _RegAndLoginState createState() => _RegAndLoginState();
}

class _RegAndLoginState extends State<RegPageAndLoginPage> {
  final TextEditingController _phoneNum = TextEditingController();
  final TextEditingController _password = TextEditingController();

  ///用户账号
  String _account = '';

  ///用户密码
  String _pwd = '';
  String _smsCode = '';
  bool isSendSms = false;

  bool _isObscure = true;
  IconData _icon = IconFonts.eye_close;

  // Widget _getHeader() {
  //   if (widget.index != null && widget.index.isNotEmpty && widget.index != 'from_setting_logout_to_member_page') {
  //     return CommonBackTopBar(
  //         title: "登入註冊", onBack: () => Navigator.pop(context));
  //   } else {
  //     return CommonTopBar(
  //         title: '登入註冊');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);

    return Scaffold(
      appBar: MyAppBar(
        preferredSize: Size.fromHeight(AppSize.height(160)),
        //child: _getHeader(),
        child: CommonBackTopBar(
            title: "登入註冊", onBack: () {
          Navigator.pop(context);
          if (widget.index != null && widget.index.isNotEmpty && widget.index == 'from_setting_logout_to_member_page') {
            eventBus.fire(IndexInEvent('0'));
          }
        }),
      ),
      body:
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
         },
            child:Container(
                color: ThemeColor.appBg,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: AppSize.height(450),
                        child: const Image(
                            fit: BoxFit.fill,
                            image: AssetImage('images/banner.png')),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            right: AppSize.width(60), left: AppSize.width(60)),
                        decoration: ThemeDecoration.card,
                        child: Column(
                          children: <Widget>[
                            TextField(
                              //keyboardType: TextInputType.phone,//TextInputType.phone,
                              controller: _phoneNum,
                              maxLines: 1,
                              maxLength: 10,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.phone_iphone),
                                  hintText: '請輸入手機號碼',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: AppSize.height(30))),
                              onChanged: (String inputStr) {
                                print('_account   ' + inputStr);
                                _account = inputStr;
                                //kun加入
                                if(isSendSms == true && _account.length == 10) {
                                  setState(() {

                                  });
                                }
                              },
                            ),
                            _buildSmsInputOrPasswordInput(),
                            InkWell(
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                if(isSendSms == true){
                                  if(_account.isNotEmpty && _smsCode.isNotEmpty) {
                                    loadLoginOrReg(_account, _smsCode);
                                  }
                                }
                                else{
                                  if(_account.isNotEmpty && _pwd.isNotEmpty) {
                                    loadLoginByPass(_account, _pwd);
                                  }
                                }
                                // isSendSms
                                //     ? loadLoginOrReg(_account, _smsCode)
                                //     : loadLoginByPass(_account, _pwd);
                              },
                              child: Container(
                                width: double.infinity,
                                height: AppSize.height(100),
                                padding: EdgeInsets.only(
                                    right: AppSize.width(60),
                                    left: AppSize.width(60)),
                                child: Center(
                                    child: Text(
                                      '登入',
                                      style: TextStyle(
                                          fontSize: AppSize.sp(45),
                                          color: Colors.white),
                                    )),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      ThemeColor.loignColor,
                                      ThemeColor.loignColor
                                    ]),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(1.0, 5.0),
                                        color: ThemeColor.loignColor,
                                        blurRadius: 5.0,
                                      )
                                    ]),
                              ),
                            ),
                            _buildSmsOrPass(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
           )
        )
    );
  }

  Widget _buildSmsInputOrPasswordInput() {
    return isSendSms
        ? Padding(
            padding: EdgeInsets.only(
                top: AppSize.height(30), bottom: AppSize.height(60)),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      hintText: '請輸入驗証碼',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15.0),
                    ),
                    onChanged: (String inputStr) {
                      print('smscode   ' + inputStr);
                      _smsCode = inputStr;
                    },
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(
                      top: AppSize.height(30),
                      left: AppSize.width(600),
                      right: AppSize.width(30),
                    ),
                    width: AppSize.width(486.0),
                    child: ResetCodePage(
                        onTapCallback: () {}, phoneNum: _account))
              ],
            ),
          )
        : Padding(
            padding: EdgeInsets.only(
                top: AppSize.height(30), bottom: AppSize.height(60)),
            child: TextField(
              controller: _password,
              maxLines: 1,
              maxLength: 32,
              obscureText: _isObscure,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                hintText: '請輸入登入密碼',
                contentPadding:
                    EdgeInsets.symmetric(vertical: AppSize.height(30)),
                suffixIcon: IconButton(
                    icon: Icon(
                      _icon,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                        _icon = _isObscure
                            ? IconFonts.eye_close
                            : Icons.remove_red_eye;
                      });
                    }),
              ),
              onChanged: (inputStr) {
                print('password   ' + inputStr);
                _pwd = inputStr;
              },
            ),
          );
  }
  /// 返回用戶或短信登錄
  Widget _buildSmsOrPass() {
    final String buttonName = isSendSms ? '用戶名密碼登入':'手機短信登入/註冊';
    return InkWell(
      onTap: () {
        setState(() {
          isSendSms = !isSendSms;
        });
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: AppSize.height(30)),
        padding: EdgeInsets.symmetric(vertical: AppSize.height(20)),
        child: Center(
            child: Text(
          buttonName,
          style: TextStyle(fontSize: AppSize.sp(45), color: Colors.white),
        )),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [ThemeColor.appBarTopBg, ThemeColor.appBarBottomBg]),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                offset: const Offset(1.0, 5.0),
                color: ThemeColor.appBarBottomBg,
                blurRadius: 5.0,
              )
            ]),
      ),
    );
  }

  // ignore: avoid_void_async
  void loadLoginByPass(String _account, String password) async {
    EasyLoading.show(status: '登入中...');
    final LoginEntity entity = await LoginDao.fetch(_account, password);
    //final LoginEntity entity = await LoginDao.fetch('jiwell',/*'123456'*/'123456');
    if (entity?.userModel != null) {
      saveUserInfo(entity.userModel,'');
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      ToastUtil.buildToast(entity.msgModel.msg);
    }
  }

  // ignore: avoid_void_async
  void loadLoginOrReg(String _account, String smsCode) async {
    EasyLoading.show(status: '登入中...');
    final LoginEntity entity = await LoginRegDao.fetch(_account, smsCode);
    if (entity?.userModel != null) {
      EasyLoading.dismiss();
      saveUserInfo(entity.userModel,entity.userModel.registerState);
      //EasyLoading.dismiss();
      // if (entity.userModel.registerState == 'REGISTER') {
      //   //Navigator.pop(context);
      //   showDialog<bool>(
      //       context: context,
      //       builder: (BuildContext context) {
      //         return AlertDialog(
      //           title: const Text('更新個人資料？'),
      //           content: const Text('第一次登入，是否要更新個人資料？'),
      //           actions: <Widget>[
      //             FlatButton(
      //               child: const Text('取消'),
      //               onPressed: () => Navigator.of(context).pop(false),
      //             ),
      //             FlatButton(
      //               child: const Text('確定'),
      //               onPressed: () async {
      //                 Routes.instance.navigateTo(context, Routes.setting_page);
      //               },
      //             ),
      //           ],
      //         );
      //       });
      //
      // }
    } else {
      if(entity?.msgModel!=null) {
        EasyLoading.dismiss();
        ToastUtil.buildToast(entity.msgModel.msg);
      }else{
        EasyLoading.dismiss();
        ToastUtil.buildToast('登入失敗');
      }
    }
  }

  // ignore: always_declare_return_types
  loadUserInfo(String token, String registerState) async {
    final UserEntity entity = await UserDao.fetch(token);
    if (entity?.userInfoModel != null) {
      AppConfig.gender=entity.userInfoModel.gender;
      AppConfig.avatar=entity.userInfoModel.avatar;
      AppConfig.mobile=entity.userInfoModel.mobile;
      AppConfig.nickName=entity.userInfoModel.nickName;
      AppConfig.userId=entity.userInfoModel.id;

      ToastUtil.buildToast('登入成功');
      Navigator.pop(context);
      eventBus.fire(UserLoggedInEvent('sucuss'));

      if (registerState == 'REGISTER') {
        //Navigator.pop(context);
        showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('更新個人資料？'),
                content: const Text('第一次登入，是否要更新個人資料？'),
                actions: <Widget>[
                  FlatButton(
                    child: const Text('取消'),
                    onPressed: () {
                      if(widget.index == 'from_product_details_to_car_page' || widget.index == 'from_product_spec_to_car_page'){
                        eventBus.fire(ToCarPageInEvent(widget.index));
                      }
                      else if(widget.index == 'from_product_spec_to_showBottomMenu'){
                        eventBus.fire(ToAddCarButtonInEvent(widget.index));
                      }
                      else if(widget.index == 'from_setting_logout_to_member_page'){
                        eventBus.fire(IndexInEvent('3'));
                      }
                      else if(widget.index != '-1') {
                        eventBus.fire(IndexInEvent(widget.index));
                      }
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: const Text('確定'),
                    onPressed: () async {
                      Navigator.of(context).pop(true);
                      final Map<String, String> p = {'index': widget.index};
                      Routes.instance.navigateToParams(context, Routes.setting_page, params: p);
                    },
                  ),
                ],
              );
            });

      }
      else{
        if(widget.index == 'from_product_details_to_car_page' || widget.index == 'from_product_spec_to_car_page'){
          eventBus.fire(ToCarPageInEvent(widget.index));
        }
        else if(widget.index == 'from_product_spec_to_showBottomMenu'){
          eventBus.fire(ToAddCarButtonInEvent(widget.index));
        }
        else if(widget.index == 'from_setting_logout_to_member_page'){
          eventBus.fire(IndexInEvent('3'));
        }
        else if(widget.index != '-1') {
          eventBus.fire(IndexInEvent(widget.index));
        }
      }
    } else {
      ToastUtil.buildToast(entity.msgModel.msg);
    }
  }

  /**
   * 存储用户信息
   */
  // ignore: avoid_void_async
  void saveUserInfo(UserModel userModel,String registerState) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', userModel.token);
    AppConfig.isUser = false;
    AppConfig.token =userModel.token;
    loadUserInfo(userModel.token,registerState);
    //AppConfig.loadUserInfo(registerState);
    AppConfig.registerFirebaseToken();
  }
}
