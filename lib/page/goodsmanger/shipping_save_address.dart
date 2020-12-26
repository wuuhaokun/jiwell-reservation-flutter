import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiwell_reservation/common.dart';

import 'package:jiwell_reservation/dao/save_address_dao.dart';

import 'package:jiwell_reservation/receiver/event_bus.dart';
import 'package:jiwell_reservation/res/colours.dart';
import 'package:jiwell_reservation/routes/routes.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/utils/dialog_utils.dart';
import 'package:jiwell_reservation/view/app_topbar.dart';
import 'package:jiwell_reservation/view/customize_appbar.dart';
import 'package:jiwell_reservation/view/new/pick_helper.dart';
import 'package:jiwell_reservation/view/theme_ui.dart';

import '../../functions.dart';

class ShippingSaveAddressPage extends StatefulWidget {
  @override
  _ShippingSaveAddressPageState createState() =>
      _ShippingSaveAddressPageState();
}
class _ShippingSaveAddressPageState extends State<ShippingSaveAddressPage> {

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerTel = TextEditingController();

  final TextEditingController _controllerStreet = TextEditingController();

  String name = '';
  String phone = '';
  String street = '';

  Result resultArr = Result();
  @override
  void initState() {
    super.initState();
  }

  Widget _btnSave() {
    return InkWell(
      onTap: () {
        if(name.isEmpty){
          ToastUtil.buildToast('請填寫收貨人姓名');
          return;
        }
        if(phone.isEmpty){
          ToastUtil.buildToast('請填寫手機號');
          return;
        }
        if(resultArr.areaId==null){
          ToastUtil.buildToast('請選擇區域');
          return;
        }
        if(street.isEmpty){
          ToastUtil.buildToast('請填寫詳細地址');
          return;
        }

        // ignore: always_specify_types
        final Map<String, dynamic> param = {
          'userId':AppConfig.userId,
          'addressDetail':street,
          'zipCode':resultArr.areaId,
          'city':resultArr.cityName,//縣市
          'district':resultArr.areaName,//區鎮
          'defaultAddress':_switchValue,//詳細地址
          'name':name,
          'state':resultArr.provinceName,
          'phone':phone,
          'label':'目前沒有值'};
          loadSave(param,AppConfig.token);
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
        width: AppSize.width(1080),
        height: AppSize.height(160),
        color: Colors.red,
        child: Text(
          '保存',
          style: TextStyle(color: Colors.white, fontSize: AppSize.sp(54)),
        ),
      ),
    );
  }

  // ignore: avoid_void_async
  void loadSave(Map<String, dynamic> param,String token) async{

    final bool entity = await SaveAddressDao.fetch(param,token);
    if(entity != null) {
      if(entity == true){
        Navigator.pop(context);
      }
      else{
        ToastUtil.buildToast('新增失敗！');
        return;
      }
      eventBus.fire(OrderInEvent('succuss'));
      ToastUtil.buildToast('新增成功！');
    }
    else{
      final Map<String, String> p = {'index': '-1'};
      Routes.instance.navigateToParams(context, Routes.login_page, params: p);
      AppConfig.token  = '';
    }
  }

  Widget _buildEditText(
      {double length,
      String title,
      String hint,
      TextEditingController controller,
      OnChangedCallback onChangedCallback}) {
    return Container(
      color: Colours.white,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15.0, right: length),
                child: Text(
                  title,
                  style: ThemeTextStyle.primaryStyle,
                ),
              ),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,

                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: ThemeTextStyle.detailStyle,
                  ),
                  onChanged: (String inputStr) {
                    if (null != onChangedCallback) {
                      onChangedCallback();
                    }
                  },
                  controller: controller,
                ),
                flex: 1,
              )
            ],
          ),
          ThemeView.divider(),
        ],
      ),
    );
  }

  Widget _buildAddressEditText({double length,
    String title,
    String hint,
  }) {
    return Container(
      color: Colours.white,
      child: Column(
        children: <Widget>[
          Container(
            height: AppSize.height(120.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: length),
                  child: Text(
                    title,
                    style: ThemeTextStyle.primaryStyle,
                  ),
                ),
                Expanded(

                  child:InkWell(
                    //void Function(
                    //     List<String> stringData, List<int> selecteds);
                    onTap: ()async{
                      PickHelper.openCityPicker(context, onConfirm: (List<String> stringData, List<int> selecteds){
                        resultArr.provinceName = '台灣';
                        resultArr.provinceId = '111';
                        resultArr.cityName = stringData[0];
                        resultArr.areaName = stringData[1];
                        resultArr.cityId = '92';
                        resultArr.areaId = '104';
                        int u = 0;
                        setState(() {
                        });
                      });
                      // final Result tempResult = await CityPickers.showCityPicker(
                      //     context: context,
                      //     height: 200,
                      //     cancelWidget:
                      //     Text('取消', style: TextStyle(color: Colors.blue)),
                      //     confirmWidget:
                      //     Text('確定', style: TextStyle(color: Colors.blue))
                      // );
                      // if(tempResult != null){
                      //   setState(() {
                      //     resultArr = tempResult;
                      //   });
                      // }
                    },
                    child: Text(
                      resultArr.areaId != null?getAddress(resultArr.provinceName):
                      hint,
                      style: ThemeTextStyle.primaryStyle,
                    ),
                  ),
//
                  flex: 1,
                )
              ],
            ), 
          ),
          ThemeView.divider(),
        ],
      ),
    );
  }

  String getAddress(String province){
    String res='';
    if (province.contains('北京') ||
        province.contains('重慶') ||
        province.contains('天津') ||
        province.contains('上海') ||
        province.contains('深圳') ||
        province.contains('香港') ||
        province.contains('澳門')) {
      res=resultArr.cityName+resultArr.areaName;
    }else{
      res=resultArr.provinceName+resultArr.cityName+resultArr.areaName;
    }
    return res;
  }

  ///收貨地址
  Widget _buildSwitch() {
    return Container(
      color: Colours.white,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    '設為預設收貨地址',
                    style: ThemeTextStyle.primaryStyle,
                  )),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(right: 15.0),
                  alignment: Alignment.centerRight,
                  child: CupertinoSwitch(
                      value: _switchValue,
                      onChanged: (bool value) {
                        setState(() {
                          _switchValue = value;
                        });
                      }),
                ),
                flex: 1,
              )
            ],
          ),
          ThemeView.divider(),
        ],
      ),
    );
  }

  bool _switchValue = false;

  Widget _getContent() {
      return Container(
        color: Colours.green_e5,
        child: ListView(
          children: <Widget>[
            _buildEditText(
                length: 63,
                title: '姓名',
                hint: '收貨人姓名',
                controller: _controllerName,
                // ignore: missing_return
                onChangedCallback: () {
                  name = _controllerName.text.toString();
                }),
            _buildEditText(
                length: 63,
                title: '電話',
                hint: '收貨人手機號',
                controller: _controllerTel,
                // ignore: missing_return
                onChangedCallback: () {
                  phone = _controllerTel.text.toString();
                }),
            _buildAddressEditText(
              length: 63,
              title: '地區',
              hint: '請選擇省/縣市',
            ),
            _buildEditText(
                length: 32,
                title: '詳細地址',
                hint: '街道門派、樓層房間號等信息',
                controller: _controllerStreet,
                // ignore: missing_return
                onChangedCallback: () {
                  street = _controllerStreet.text.toString();
                }),
            _buildSwitch(),
            _btnSave(),
          ],
        ),
      );
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
              title: '編輯收貨地址', onBack: () => Navigator.pop(context)),
        ),
        body: _getContent());
  }
  @override
  void dispose() {
    // ignore: flutter_style_todos
    // TODO: implement dispose
    super.dispose();

  }

}
