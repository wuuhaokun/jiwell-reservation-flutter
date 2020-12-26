import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiwell_reservation/common.dart';
import 'package:jiwell_reservation/dao/shipping_address_dao.dart';
import 'package:jiwell_reservation/models/shipping_entity.dart';
import 'package:jiwell_reservation/page/load_state_layout.dart';

import 'package:jiwell_reservation/receiver/event_bus.dart';
import 'package:jiwell_reservation/routes/routes.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/utils/dialog_utils.dart';
import 'package:jiwell_reservation/view/app_topbar.dart';
import 'package:jiwell_reservation/view/customize_appbar.dart';
import 'package:jiwell_reservation/view/theme_ui.dart';

class ShippingAddressPage extends StatefulWidget {
  @override
  _ShippingAddressPageState createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  LoadState _layoutState = LoadState.State_Loading;
  // ignore: always_specify_types
  List<ShippingAddressModel> shippingAddress = [];
  bool _isLoading = false;
  int _radioGroupAddress = 0;

  @override
  void initState() {

    super.initState();
    _isLoading = true;
    // ignore: always_specify_types
    Future.microtask(() =>
        loadData()
    );

  }

  // ignore: avoid_void_async
  void loadData() async {
    final ShippingAddresEntry entity =
        await ShippingAddressDao.fetch(AppConfig.token);
    if(entity != null && (entity?.shippingAddressModels == null)){
      setState(() {//404
        _isLoading = false;
        _layoutState = LoadState.State_Success;
      });
    }
    else if (entity?.shippingAddressModels != null ) {
      if (entity.shippingAddressModels.length > 0) {
        final List<ShippingAddressModel> shippingAddressTemp = [];
        for (int i = 0; i < entity.shippingAddressModels.length; i++) {
          if (entity.shippingAddressModels[i].defaultAddress) {
            _radioGroupAddress = i;
          }
          shippingAddressTemp.add(entity.shippingAddressModels[i]);
        }

        if (mounted) {
          setState(() {
            _isLoading = false;
            _layoutState = LoadState.State_Success;
            shippingAddress.clear();
            shippingAddress.addAll(shippingAddressTemp);
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _layoutState = LoadState.State_Empty;
          });
        }
      }
    } else {
      if (mounted) {
        EasyLoading.showInfo('取得地址失敗，請稍後在試..');
        Timer(Duration(seconds:1), (){
          EasyLoading.dismiss();
        });
        //AppConfig.token  = '';
        //ToastUtil.buildToast('token失败');
        //Navigator.pop(context);
        // ignore: always_specify_types
        //final Map<String, String> p = {'index': '-1'};
        //Routes.instance.navigateToParams(context, Routes.login_page, params: p);
        setState(() {//_layoutState = LoadState.State_Error;
          _isLoading = false;
           _layoutState = LoadState.State_Error;
        });
      }
    }
  }

  void _handleRadioValueChanged(int value) {
    setState(() {
      _radioGroupAddress = value;
    });
  }

  Widget _btnBottom() {
    return InkWell(
      onTap: () {
        if(AppConfig.token.isNotEmpty)  {
          Routes.instance.navigateTo(context, Routes.new_address_page);
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: AppSize.width(1080),
        height: AppSize.height(160),
        color: Colors.red,
        child: Text(
          '新增地址',
          style: TextStyle(color: Colors.white, fontSize: AppSize.sp(54)),
        ),
      ),
    );
  }

  ///數據為空的視圖
  Widget get _emptyView {
    return Container(
      margin: EdgeInsets.only(bottom: AppSize.height(160)),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'images/ic_empty.png',
            height: 100,
            width: 100,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text('暫無數據'),
          )
        ],
      ),
    );
  }

  Widget _getContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Stack(
        children: <Widget>[
          ((shippingAddress.length > 0)?ListView.builder(
              itemCount: shippingAddress.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildItemAdress(index);
              }):_emptyView)
          ,
          Positioned(bottom: 0, left: 0, child: _btnBottom())
        ],
      );
    }
  }

  Widget _buildItemAdress(int index) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      height: AppSize.height(140.0),
      color: Colors.white,
      width: AppSize.width(1080),
      child: Row(
        children: <Widget>[
          Checkbox(
              value: _radioGroupAddress == index,
              activeColor: Colors.pink,
              onChanged: (bool val) {
                _handleRadioValueChanged(index);
              }),
          Text(shippingAddress[index].name + '   ' + shippingAddress[index].phone,
              style: ThemeTextStyle.personalShopNameStyle),
          Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    width: AppSize.width(128),
                    child:  IconButton(
                      icon: Icon(CupertinoIcons.create, size: 30),
                      onPressed: (){
                        final String id = shippingAddress[index].id;
                        // ignore: always_specify_types
                        final Map<String,String> p = {'id': id,'index':index.toString()};
                        Routes.instance.navigateToParams(
                            context, Routes.save_address_page,
                            params: p);
                      },
                      color: Colors.blueAccent,
                      highlightColor: Colors.red,
                    ),
                  )

                ),
              flex: 1)
        ],
      ),
    );
  }

  // ignore: always_specify_types
  StreamSubscription _saveSubscription;

  ///监听Bus events
  void _listen() {
    _saveSubscription = eventBus.on<OrderInEvent>().listen((OrderInEvent event) {
      if ('succuss' == event.text) {
       loadData();
      }
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
              title: '收貨地址', onBack: () => Navigator.pop(context)),
        ),
        body: LoadStateLayout(
            state: _layoutState,
            errorRetry: () {
              setState(() {
                _layoutState = LoadState.State_Loading;
              });
              _isLoading = true;
              loadData();
            },
            successWidget: _getContent()));
  }

  @override
  void dispose() {
    // ignore: flutter_style_todos
    // TODO: implement dispose
    super.dispose();

    _saveSubscription.cancel();
  }
}
