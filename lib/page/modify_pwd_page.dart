import 'package:flutter/material.dart';
import 'package:jiwell_reservation/common.dart';

import 'package:jiwell_reservation/dao/save_pwd_dao.dart';

import 'package:jiwell_reservation/models/msg_entity.dart';

import 'package:jiwell_reservation/res/colours.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/utils/dialog_utils.dart';
import 'package:jiwell_reservation/view/app_topbar.dart';
import 'package:jiwell_reservation/view/customize_appbar.dart';
import 'package:jiwell_reservation/view/theme_ui.dart';


class ModifyPwdPage extends StatefulWidget {
  @override
  _ModifyPwdPageState createState() => _ModifyPwdPageState();
}

class _ModifyPwdPageState extends State<ModifyPwdPage>{
  String _inputOldText = '';
  String _inputNewText = '';
  String _inputAginText = '';

  Widget _buildPwdOld() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        '*',
                        style: ThemeTextStyle.cardPriceStyle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '舊密碼',
                        style: TextStyle(
                            color: Colours.text_dark,
                            fontSize: 14,
                            decoration: TextDecoration.none),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child:
                      TextField(
                        textAlign: TextAlign.end,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "請輸入舊密碼",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 15.0),
                        ),
                        onChanged: (inputStr) {
                          _inputOldText = inputStr;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ThemeView.divider(),
        ],
      ),
    );
  }
  Widget _buildPwdNew() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        '*',
                        style: ThemeTextStyle.cardPriceStyle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '新密碼',
                        style: TextStyle(
                            color: Colours.text_dark,
                            fontSize: 14,
                            decoration: TextDecoration.none),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child:
                      TextField(
                        textAlign: TextAlign.end,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "請輸入新密碼",
                          hintStyle:
                          TextStyle(color: Colors.grey, fontSize: 15.0),
                        ),
                        onChanged: (inputStr) {
                          _inputNewText = inputStr;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ThemeView.divider(),
        ],
      ),
    );
  }
  Widget _buildPwdAgin() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        '*',
                        style: ThemeTextStyle.cardPriceStyle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '確認密碼',
                        style: TextStyle(
                            color: Colours.text_dark,
                            fontSize: 14,
                            decoration: TextDecoration.none),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child:
                      TextField(
                        textAlign: TextAlign.end,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "請確認密碼",
                          hintStyle:
                          TextStyle(color: Colors.grey, fontSize: 15.0),
                        ),
                        onChanged: (inputStr) {
                          _inputAginText = inputStr;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ThemeView.divider(),
        ],
      ),
    );
  }

  Widget _btnSave() {
  return Container(
    margin: EdgeInsets.only(top: 10),
    child:Center(

      child:Material(
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(new Radius.circular(25.0)),
          ),
          child: InkWell(
            borderRadius: new BorderRadius.circular(25.0),
            onTap: () {
              if(_inputOldText.isEmpty){
                ToastUtil.buildToast('請輸入舊密碼');
                //return;
              }
              if(_inputNewText.isEmpty){
                ToastUtil.buildToast('請輸入新密碼');
                //return;
              }
              if(_inputAginText.isEmpty){
                ToastUtil.buildToast('請確認密碼');
                //return;
              }

              loadSave(_inputOldText,_inputNewText,_inputAginText,AppConfig.token);
            },
            child: Container(
              width: 300.0,
              height: 50.0,
              //设置child 居中
              alignment: Alignment(0, 0),
              child: Text("保   存",style: TextStyle(color: Colors.white,fontSize: 16.0),),
            ),
          ),
        ),
      ),
    ) ,
  );



  }

  void loadSave(String old,String newPwd,String aginPwd, String token) async {
    //bool result = await SavePwdDao.fetch(old, newPwd,aginPwd,token);
    bool result = await SavePwdDao.fetch('lyj123123', '123456','123456',token);
    if (result == true) {
      //if (entity.msgModel.code == 20000) {
        Navigator.pop(context);
      //}

      ToastUtil.buildToast('更新成功');
    } else {
      ToastUtil.buildToast('失敗');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    AppSize.init(context);
    return Scaffold(
      appBar: MyAppBar(
          preferredSize: Size.fromHeight(AppSize.height(160)),
          child: CommonBackTopBar(
              title: "修改密碼", onBack: () => Navigator.pop(context))),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[_buildPwdOld(),_buildPwdNew(),_buildPwdAgin(), _btnSave()],
        ),
      ),
    );
  }
}
