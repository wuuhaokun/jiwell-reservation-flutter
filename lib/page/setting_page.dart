import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiwell_reservation/common.dart';

import 'package:jiwell_reservation/dao/file_upload_dao.dart';
import 'package:jiwell_reservation/dao/save_sex_dao.dart';

import 'package:jiwell_reservation/models/file_upload_entity.dart';
import 'package:jiwell_reservation/models/msg_entity.dart';

import 'package:jiwell_reservation/receiver/event_bus.dart';
import 'package:jiwell_reservation/res/colours.dart';
import 'package:jiwell_reservation/routes/routes.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/utils/bottom_dialog.dart';
import 'package:jiwell_reservation/utils/dialog_utils.dart';
import 'package:jiwell_reservation/view/app_topbar.dart';
import 'package:jiwell_reservation/view/custom_view.dart';
import 'package:jiwell_reservation/view/customize_appbar.dart';
import 'package:jiwell_reservation/view/flutter_iconfont.dart';
import 'package:jiwell_reservation/view/my_icons.dart.dart';
import 'package:jiwell_reservation/view/theme_ui.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  String index = '999';
  SettingPage({this.index});
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String imgUrl =
      'http://linjiashop-mobile-api.microapp.store/file/getImgStream?idFile=';
  File primaryFile;
  File compressedFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _userSubscription.cancel();
  }

  ///修改姓名
  Widget _buildModifyName() {
    return InkWell(
        onTap: () {
          // ignore: always_specify_types
          final Map<String, String> p = {'name': AppConfig.nickName};
          Routes.instance
              .navigateToParams(context, Routes.modify_name_page, params: p);
        },
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(CupertinoIcons.profile_circled),
                        ),
                        Expanded(
                          child: Text(
                            '姓名',
                            style: TextStyle(
                                color: Colours.text_dark,
                                fontSize: 14,
                                decoration: TextDecoration.none),
                          ),
                          flex: 1,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(right: 3.0),
                            child: Text(AppConfig.nickName,
                                style: TextStyle(
                                    color: Colours.text_gray,
                                    fontSize: 14,
                                    decoration: TextDecoration.none))),
                        Icon(IconFonts.arrow_right),
                      ],
                    ),
                  ],
                ),
              ),
              ThemeView.divider(),
            ],
          ),
        ));
  }

  ///修改密码
  Widget _buildModifyPwd() {
    return InkWell(
        onTap: () {
          Routes.instance.navigateTo(context, Routes.modify_pwd_page);
        },
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.lock_outline),
                        ),
                        Expanded(
                          child: Text(
                            '修改密码',
                            style: TextStyle(
                                color: Colours.text_dark,
                                fontSize: 14,
                                decoration: TextDecoration.none),
                          ),
                          flex: 1,
                        ),
                        Icon(IconFonts.arrow_right),
                      ],
                    ),
                  ],
                ),
              ),
              ThemeView.divider(),
            ],
          ),
        ));
  }
  ///更換手機
  Widget _buildChangePhone() {
    return InkWell(
        onTap: () {
          //ToastUtil.buildToast('敬請期待');
        },
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.phone_forwarded),
                        ),
                        Expanded(
                          child: Text(
                            '手機',//更換手機
                            style: TextStyle(
                                color: Colours.text_dark,
                                fontSize: 14,
                                decoration: TextDecoration.none),
                          ),
                          flex: 1,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(right: 3.0),
                            child: Text(AppConfig.mobile,
                                style: TextStyle(
                                    color: Colours.text_gray,
                                    fontSize: 14,
                                    decoration: TextDecoration.none))),
                        Icon(IconFonts.arrow_right),
                      ],
                    ),
                  ],
                ),
              ),
              ThemeView.divider(),
            ],
          ),
        ));
  }
  String getGender(String str) {
    if ('male' == str) {
      return '男';
    } else {
      return '女';
    }
  }

  Widget _buildSex() {
    return InkWell(
        onTap: () {
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                // ignore: always_specify_types
                final List list = [];
                list.add('男');
                list.add('女');
                return CommonBottomSheet(
                  //uses the custom alert dialog
                  list: list,
                  onItemClickListener: (int index) {
                    if (index == 0) {
                      Navigator.pop(context);
                      loadSexSave('male', AppConfig.token);
                    } else if (index == 2) {
                      Navigator.pop(context);
                      loadSexSave('female', AppConfig.token);
                    }
                  },
                );
              });
        },
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(MyIcons.sexicon),
                        ),
                        Expanded(
                          child: Text(
                            '性别',
                            style: TextStyle(
                                color: Colours.text_dark,
                                fontSize: 14,
                                decoration: TextDecoration.none),
                          ),
                          flex: 1,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(right: 3.0),
                            child: Text(
                                AppConfig.gender.isEmpty
                                    ? '請選擇'
                                    : getGender(  AppConfig.gender),
                                style: TextStyle(
                                    color: Colours.text_gray,
                                    fontSize: 14,
                                    decoration: TextDecoration.none))),
                        Icon(IconFonts.arrow_right),
                      ],
                    ),
                  ],
                ),
              ),
              ThemeView.divider(),
            ],
          ),
        ));
  }

  // ignore: avoid_void_async
  void loadSexSave(String sex, String token) async {
    setState(() {
      AppConfig.gender = sex;
    });
    return;//kun edit
    MsgEntity entity = await SaveSexDao.fetch(sex, token);
    if (entity?.msgModel != null) {
      if (entity.msgModel.code == 20000) {
        setState(() {
          AppConfig.gender=sex;
        });
      }
      ToastUtil.buildToast(entity.msgModel.msg);
    } else {
      ToastUtil.buildToast('失败');
    }
  }

  // ignore: always_specify_types
  StreamSubscription _userSubscription;

  ///监听Bus events
  void _listen() {
    _userSubscription = eventBus.on<UserInfoInEvent>().listen((UserInfoInEvent event) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: flutter_style_todos
    // TODO: implement build
    AppSize.init(context);
    _listen();

    return Scaffold(
      appBar: MyAppBar(
          preferredSize: Size.fromHeight(AppSize.height(160)),
          child: CommonBackTopBar(
              title: '設置', onBack:() {
            Navigator.pop(context);
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
          })),//=> Navigator.pop(context))),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ///頭像
            _buildContainerHeader(),
            ///姓名
            _buildModifyName(),
            ///性別
            _buildSex(),
            ///密碼
            _buildModifyPwd(),
            ///更換手機
            _buildChangePhone(),
            _btnExit(context)
          ],
        ),
      ),
    );
  }
  ///退出登錄
  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('溫馨提示'),
          content: const Text('確定要退出登錄嗎？'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('確定'),
              onPressed: () async {
                Navigator.pop(context);
                AppConfig.clearUserInfo();
                // AppConfig.token='';
                // final SharedPreferences prefs = await SharedPreferences.getInstance();
                // prefs.setString('token', '');
                //
                // AppConfig.isUser = false;
                // AppConfig.orderIndex=0;
                // AppConfig.token='';
                // AppConfig.gender='';
                // AppConfig.avatar='';
                // AppConfig.mobile='';
                // AppConfig.nickName='';
                // AppConfig.userId='';
                // AppConfig.firebaseToken ='';

                Navigator.pop(context);
                //Routes.instance.navigateTo(context,Routes.ROOT);
                //Navigator.popUntil(context, ModalRoute.withName(Routes.ROOT));
                final Map<String, String> p = {'index':'from_setting_logout_to_member_page'};
                Routes.instance.navigateToParams(context, Routes.login_page,params: p);
              },
            ),
          ],
        );
      },
    );
  }
  Widget _btnExit(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child:Center(

        child:Material(
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: const BorderRadius.all(const Radius.circular(25.0)),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: ()  {
                _showExitDialog(context);
              },
              child: Container(
                width: 300.0,
                height: 50.0,
                //设置child 居中
                alignment: const Alignment(0, 0),
                child: Text('退出登錄',style: TextStyle(color: Colors.white,fontSize: 16.0),),
              ),
            ),
          ),
        ),
      ) ,
    );

  }

  ///頭像是否為空
  Widget _buildIsHasHead() {
    if (AppConfig.avatar.isEmpty) {
      return Image.asset(
        'images/icon_user.png',
        width: 28.0,
        height: 28.0,
      );
    } else {
      return CircleAvatar(
          radius: 16, backgroundImage: NetworkImage(imgUrl + AppConfig.avatar));
    }
  }

  ///頭像
  Container _buildContainerHeader() {
    return Container(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                // ignore: always_specify_types
                final List list = [];
                list.add('拍照');
                list.add('相册');
                return CommonBottomSheet(
                  //uses the custom alert dialog
                  list: list,
                  onItemClickListener: (int index) {
                    if (index == 0) {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    } else if (index == 2) {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    }
                  },
                );
              });
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.local_florist),
                      ),
                      Expanded(
                        child: Text(
                          '頭像',
                          style: TextStyle(
                              color: Colours.text_dark,
                              fontSize: 14,
                              decoration: TextDecoration.none),
                        ),
                        flex: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 3.0),
                        child: _buildIsHasHead(),
                      ),
                      Icon(IconFonts.arrow_right),
                    ],
                  ),
                ],
              ),
            ),
            ThemeView.divider(),
          ],
        ),
      ),
    );
  }

  String getImageBase64(File image) {
    final Uint8List bytes = image.readAsBytesSync();
    final String base64 = base64Encode(bytes);
    return base64;
  }

  ///上傳頭像
  Future<void> _pickImage(ImageSource type) async {

    final File imageFile = await ImagePicker.pickImage(source: type);
    setState(() {
      primaryFile = imageFile;
    });
    // ignore: always_put_control_body_on_new_line
    if (imageFile == null) return;
    final Directory tempDir = await getTemporaryDirectory();

    final CompressObject compressObject = CompressObject(
      imageFile: imageFile, //image
      path: tempDir.path, //compress to path
      quality: 85, //first compress quality, default 80
      step:
          6, //compress quality step, The bigger the fast, Smaller is more accurate, default 6
    );


    Luban.compressImage(compressObject).then((_path) {
      compressedFile = File(_path);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return LoadingDialog(
              text: '圖片上傳中..',
            );
          });
      final String strContent = getImageBase64(compressedFile);
      // ignore: always_specify_types
      final Map<String, dynamic> param = {
        'base64': strContent,
        'name': 'logo.jpg',
        'type': 'image/jpeg'
      };
      loadSave(param,AppConfig.token);
    });
  }

  // ignore: avoid_void_async
  void loadSave(Map<String, dynamic> param, String token) async {
    final FileEntity entity = await FileUploadDao.fetch(param, token);
    if (entity?.msgModel != null) {
      setState(() {
        AppConfig.avatar = entity.msgModel.avatar;
      });
    }
    Navigator.pop(context);
    ToastUtil.buildToast(entity.msgModel.msg);
  }

}
