import 'package:flutter/material.dart';
import 'package:jiwell_reservation/common.dart';

import 'package:jiwell_reservation/dao/save_name_dao.dart';

import 'package:jiwell_reservation/models/msg_entity.dart';

import 'package:jiwell_reservation/res/colours.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/utils/dialog_utils.dart';
import 'package:jiwell_reservation/view/app_topbar.dart';
import 'package:jiwell_reservation/view/customize_appbar.dart';
import 'package:jiwell_reservation/view/theme_ui.dart';


// ignore: must_be_immutable
class ModifyNamePage extends StatefulWidget {
  String name;

  // ignore: sort_constructors_first
  ModifyNamePage({this.name});

  @override
  _ModifyNamePageState createState() => _ModifyNamePageState();
}

class _ModifyNamePageState extends State<ModifyNamePage> {
  String _inputText = '';

  Widget _buildName() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        '*',
                        style: ThemeTextStyle.cardPriceStyle,
                      ),
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
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.end,
                        controller: TextEditingController.fromValue(
                            TextEditingValue(
                                text: _inputText.isEmpty
                                    ? widget.name
                                    : _inputText,
                                // 保持光标在最后
                                selection: TextSelection.fromPosition(
                                    TextPosition(
                                        affinity: TextAffinity.downstream,
                                        offset:_inputText.isEmpty
                                            ? widget.name.length
                                            : _inputText.length)))),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '請輸入姓名',
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 15.0),
                        ),
                        onChanged: (String inputStr) {
                          _inputText = inputStr;
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
      margin: const EdgeInsets.only(top: 10),
      child:Center(
        child:Material(
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: const BorderRadius.all(Radius.circular(25.0)),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: () {
                if (_inputText.isNotEmpty)
                  loadSave(_inputText, AppConfig.token);
                else
                  ToastUtil.buildToast('姓名没有修改');
              },
              child: Container(
                width: 300.0,
                height: 50.0,
               //设置child 居中
                alignment: const Alignment(0, 0),
                child: Text('保   存',style: TextStyle(color: Colors.white,fontSize: 16.0),),
              ),
            ),
          ),
        ),
      ) ,
    );
  }

  // ignore: avoid_void_async
  void loadSave(String name, String token) async {
    final MsgEntity entity = await SaveNameDao.fetch(name, token);
    if (entity?.msgModel != null) {
      ToastUtil.buildToast(entity.msgModel.msg);
      if (entity.msgModel.code == 20000) {
        AppConfig.nickName  = name;
        Navigator.pop(context);
      }
    } else {
      ToastUtil.buildToast('失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: flutter_style_todos
    // TODO: implement build
    AppSize.init(context);
    return Scaffold(
      appBar: MyAppBar(
          preferredSize: Size.fromHeight(AppSize.height(160)),
          child: CommonBackTopBar(
              title: '修改姓名', onBack: () => Navigator.pop(context))),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[_buildName(), _btnSave()],
        ),
      ),
    );
  }

}
