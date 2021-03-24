

import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiwell_reservation/common.dart';

import 'package:jiwell_reservation/dao/save_address_dao.dart';
import 'package:jiwell_reservation/dao/shipping_address_dao.dart';

import 'package:jiwell_reservation/models/shipping_entity.dart';

import 'package:jiwell_reservation/page/load_state_layout.dart';

import 'package:jiwell_reservation/receiver/event_bus.dart';
import 'package:jiwell_reservation/res/colours.dart';

import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/utils/dialog_utils.dart';
import 'package:jiwell_reservation/view/app_topbar.dart';
import 'package:jiwell_reservation/view/customize_appbar.dart';
import 'package:jiwell_reservation/view/theme_ui.dart';


import '../../functions.dart';

// ignore: must_be_immutable
class ShippingEditAddressPage extends StatefulWidget {
  final String id;
  final String index;
  // ignore: sort_constructors_first
  const ShippingEditAddressPage({this.id,this.index});

  @override
  _ShippingEditAddressPageState createState() =>
      _ShippingEditAddressPageState();
}

class _ShippingEditAddressPageState extends State<ShippingEditAddressPage>  {
  //AddressModel addressModelInfo=AddressModel();
  ShippingAddressModel shippingAddressModel = ShippingAddressModel();
  TextEditingController _controllerName;
  TextEditingController _controllerTel;

  TextEditingController _controllerStreet ;
  LoadState _layoutState = LoadState.State_Loading;
  String name = '';
  String phone = '';

  String street = '';
  bool _isLoading = false;
 Result resultArr = Result();
  @override
  void initState() {
    _isLoading = true;
    loadData(AppConfig.token);
    super.initState();
  }

  // ignore: avoid_void_async
  void loadData(String token) async {
    final ShippingAddresEntry entity =
    await ShippingAddressDao.fetch(AppConfig.token);
    shippingAddressModel = entity.shippingAddressModels[int.parse(widget.index)];
    if (entity.shippingAddressModels[int.parse(widget.index)] != null) {
      phone = shippingAddressModel.phone;
      name = shippingAddressModel.name;
      street = shippingAddressModel.address;

      _switchValue = shippingAddressModel.defaultAddress;
      _controllerName=TextEditingController.fromValue(
          TextEditingValue(
              text: shippingAddressModel.name ?? '',
              selection:TextSelection.fromPosition(TextPosition(
                  affinity: TextAffinity.downstream,
                  offset: shippingAddressModel.name==null?0:shippingAddressModel.name.length
              )))
      );
      _controllerTel = TextEditingController.fromValue(
          TextEditingValue(
              text: shippingAddressModel.phone ?? '',
              selection:TextSelection.fromPosition(TextPosition(
                  affinity: TextAffinity.downstream,
                  offset: shippingAddressModel.phone == null? 0:shippingAddressModel.phone.length
              )))
      );

      _controllerStreet  = TextEditingController.fromValue(
          TextEditingValue(
              text: shippingAddressModel.address ?? '',
              selection:TextSelection.fromPosition(TextPosition(
                  affinity: TextAffinity.downstream,
                  offset: shippingAddressModel.address==null? 0:shippingAddressModel.address.length
              )))
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
          _layoutState = LoadState.State_Success;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _layoutState = LoadState.State_Error;
        });
      }
    }
  }

  Widget _btnSave() {
    return InkWell(
      onTap: () {
        // ignore: always_specify_types
        final Map<String, dynamic> param = {'address':street,
          'zipCode':resultArr.areaId ?? shippingAddressModel.zipCode,
          'city':resultArr.areaId!=null?resultArr.cityName:shippingAddressModel.city,
          'district':resultArr.areaId!=null?resultArr.areaName:shippingAddressModel.district,
          'id':int.parse(shippingAddressModel.id),
          'defaultAddress':_switchValue,
          'name':name,
          'state':resultArr.provinceId!=null?resultArr.provinceName:shippingAddressModel.state,
          'phone':phone,'userId':shippingAddressModel.userId,'label': shippingAddressModel.label};
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

    final bool entity = await EditAddressDao.fetch(param,token);
    if(entity != null) {
      if(entity == true){
        Navigator.pop(context);
      }
      else{
        ToastUtil.buildToast('更改失敗！');
        return;
      }
      eventBus.fire(OrderInEvent('succuss'));
      ToastUtil.buildToast('更改成功！');
    }
    else{
      ToastUtil.buildToast('服務器錯誤~');
    }
  }

  Widget _buildEditText(
      {double length,
      String title,
      String hint, TextInputType keyboardType,
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
                  keyboardType: keyboardType,

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
                    onTap: ()async{
                      final Result tempResult = await CityPickers.showCityPicker(
                          context: context,
                          height: 200,
                          locationCode: resultArr.areaId ?? shippingAddressModel.zipCode,
                          cancelWidget:
                          Text('取消', style: TextStyle(color: Colors.blue)),
                          confirmWidget:
                          Text('確定', style: TextStyle(color: Colors.blue))
                      );
                      if(tempResult != null){
                        setState(() {
                          resultArr = tempResult;
                        });
                      }
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
 String getAddressHit(String province){
   String res='';
   if (province.contains('北京') ||
       province.contains('重慶') ||
       province.contains('天津') ||
       province.contains('上海') ||
       province.contains('深圳') ||
       province.contains('香港') ||
       province.contains('澳門')) {
     res = shippingAddressModel.city + shippingAddressModel.district;
   }else{
     res = shippingAddressModel.state + shippingAddressModel.city + shippingAddressModel.district;
   }
   return res;

 }
  ///收货地址
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
                    '设为默认收货地址',
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
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
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
              hint:getAddressHit(shippingAddressModel.state),
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
        body: LoadStateLayout(
            state: _layoutState,
            errorRetry: () {
              setState(() {
                _layoutState = LoadState.State_Loading;
              });
              _isLoading = true;
              loadData(AppConfig.token);
            },
            successWidget: _getContent()));
  }
  @override
  void dispose() {
    // ignore: flutter_style_todos
    // TODO: implement dispose
    super.dispose();

  }

}
