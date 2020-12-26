import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jiwell_reservation/models/new/specifications_entity.dart';
import 'package:jiwell_reservation/models/new/spus_entity.dart';
import 'package:jiwell_reservation/page/new/single_popup.dart';
import 'package:jiwell_reservation/receiver/event_bus.dart';
import 'package:jiwell_reservation/res/colours.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/utils/image_utils.dart';
import 'package:jiwell_reservation/view/theme_ui.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:smart_select/smart_select.dart';

import 'multi_popup.dart';

/**
 * 商品詳情頭部
 */

// ignore: must_be_immutable
class SpecsTopArea extends StatefulWidget {
  List<String> gallery = [];
  List<ParamsModel> params = [];

  List<WskuModel> skuModelLists = [];
  SpecsTopArea({Key key,this.gallery,this.params,this.skuModelLists}):super(key:key);
  @override
  _SpecsTopAreaState createState() => _SpecsTopAreaState();
}

class _SpecsTopAreaState extends State<SpecsTopArea>  {
  String imgUrl="http://linjiashop-mobile-api.microapp.store/file/getImgStream?idFile=";
  String ownSpec = '';
  WskuModel _skuModel;
  List<String> ownSpecList = [];
  List<String> localSpecList = [];
  int ownSpecCurrentIndex = -1;

  List<String> _localOwnSpecList = [];
  List<String> _globalOwnSpeclist = [];

  int _globalOwnSpecIndex = 0;
  int _localOwnSpecIndex = 0;

  Map<String,dynamic> ownSpecMap = {};

  @override
  Widget build(BuildContext context) {
            //priceGoods=price/100;
            return Container(
              //color: Colours.divider,
              color: Colours.white,
              child: Column(
                children: _specWidgetList()
                  //_goodsImage(),
                  //_goodsName(),
                  //_goodsComment(),
                //],
              ),
            );
  }

  @override
  void initState() {
    super.initState();
    _listen();
    _localOwnSpecList.clear();
    _globalOwnSpeclist.clear();
    for (WskuModel wSku in widget.skuModelLists) {
      _skuModel = wSku;
      _localOwnSpecList = _skuModel.indexes.split('_');
      break;
    }
    widget.params.forEach((v){
      if((v.options != null && v.options.length > 0) ||
          (v.multipleOptions != null && v.multipleOptions.length > 0) ) {
        if(v.global == true){
          if(v.options.length > 0) {
            _globalOwnSpeclist.add('0');
            ownSpecMap[v.k] = v.options[0].name;
          }
          if(v.multipleOptions.length > 0){
            _globalOwnSpeclist.add('');
            ownSpecMap[v.k] = '';
          }
        }
        else{
          if(v.options.length > 0) {
            _globalOwnSpeclist.add('0');
            //OptionsModel optionsModel = v.options[0];
            ownSpecMap[v.k] = v.options[0].name;
          }
          if(v.multipleOptions.length > 0){
            _globalOwnSpeclist.add('');
            ownSpecMap[v.k] = '';
          }
        }
      }
    });
    eventBus.fire(SelectedSkuEvent(0,ownSpecMap));
  }

  @override
  void dispose() {
    super.dispose();
    if(_selectSpecsSingleValueSubscription != null) {
      _selectSpecsSingleValueSubscription.cancel();
      _selectSpecsSingleValueSubscription = null;
    }
    if(_selectSpecsMultiValueSubscription != null) {
      _selectSpecsMultiValueSubscription.cancel();
      _selectSpecsMultiValueSubscription = null;
    }
  }

  ///商品圖片
  Widget _goodsImage(){
    return Container(
      height: AppSize.height(640),
      width: double.infinity,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: ImageUtils.getCachedNetworkImage("${widget.gallery[index]}",BoxFit.cover,null),
            // child: Image.network(
            //   imgUrl+"${widget.gallery[index]}",
            //   fit: BoxFit.cover,
            // ),
          );
        },
        itemCount: widget.gallery.length,
        pagination: SwiperPagination(margin: EdgeInsets.all(1.0)),
        autoplay: true,
      ),
    );
  }

  ///商品名稱
  List<Widget> _specWidgetList(){
    List<Widget> widgetList = [];
    int ownIndex = 0;
    _globalOwnSpecIndex = -1;
    _localOwnSpecIndex = -1;
    widget.params.forEach((v){
      //widgetList.add(SizedBox(height: 7));
      if(v.options != null && v.options.length > 0) {
        widgetList.add(_optionWidget(v,ownIndex));
        ownIndex ++;
      }
      if(v.multipleOptions != null && v.multipleOptions.length > 0){
        widgetList.add(_multiOptionWidget(v,ownIndex));
        ownIndex ++;
      }
      //widgetList.add(Divider(indent: 20));
    });
    return widgetList;
  }

  Widget _optionWidget(ParamsModel paramsModel,int ownIndex){
    int localOwnSpecIndex = -1;
    int globalOwnSpecIndex = -1;

    String globalOwnSpecValue = '0';
    String localOwnSpecValue = '0';

    String value = '0';
    String k = paramsModel.k;
    List<S2Choice<String>> items = [];
    int index = 0;
    paramsModel.options.forEach((OptionsModel optionsModel) {
      items.add(S2Choice<String>(value: index.toString(), title: optionsModel.name));
      index ++;
    });
    if(paramsModel.global == false){
      _localOwnSpecIndex ++;
      localOwnSpecValue = _localOwnSpecList[_localOwnSpecIndex];
      localOwnSpecIndex = _localOwnSpecIndex;
    }
    else{
      _globalOwnSpecIndex ++;
      globalOwnSpecValue = _globalOwnSpeclist[_globalOwnSpecIndex];
      globalOwnSpecIndex = _globalOwnSpecIndex;
    }
    return FeaturesSinglePopup(title:k,value:localOwnSpecValue,items:items,paramsModel:paramsModel,localOwnSpecIndex: localOwnSpecIndex,globalOwnSpecIndex: globalOwnSpecIndex,ownSpecindex:ownIndex);
  }

  Widget _multiOptionWidget(ParamsModel paramsModel,int ownIndex){
    int localOwnSpecIndex = -1;
    int globalOwnSpecIndex = -1;

    String globalOwnSpecValue = '0';
    String localOwnSpecValue = '0';

    List<String> multiValue = [];
    List<String> spliteString = [];

    List<S2Choice<String>> items = [];
    int index = 0;
    paramsModel.multipleOptions.forEach((OptionsModel optionsModel) {
      items.add(S2Choice<String>(value: index.toString(), title: optionsModel.name));
      index ++;
    });
    //新加
    if(paramsModel.global == false){
      _localOwnSpecIndex ++;
      localOwnSpecValue = _localOwnSpecList[_localOwnSpecIndex];
      spliteString = localOwnSpecValue.split('');
      print(spliteString);
      int index = 0;
      for(String value in spliteString){
        if(value == '1'){
          multiValue.add(index.toString());
        }
        index ++;
      }
      localOwnSpecIndex = _localOwnSpecIndex;
    }
    else{
      _globalOwnSpecIndex ++;
      globalOwnSpecValue = _globalOwnSpeclist[_globalOwnSpecIndex];
      spliteString = globalOwnSpecValue.split('');
      print(spliteString);
      int index = 0;
      for(String value in spliteString){
        if(value == '1'){
          multiValue.add(index.toString());
          index ++;
        }
      }
      globalOwnSpecIndex = _globalOwnSpecIndex;
    }
    return FeaturesMultiPopup(title:paramsModel.k,multiValue:multiValue,items:items,paramsModel:paramsModel,localOwnSpecIndex: localOwnSpecIndex,globalOwnSpecIndex: globalOwnSpecIndex,multiCount: paramsModel.multipleOptions.length,ownSpecIndex:ownIndex);
  }

  // List<Widget> _optionsWidgetList(){
  //   List<Widget> widgetList = [];
  //   params.forEach((v){
  //     widgetList.add(specWidget(v));
  //   });
  //   return widgetList;
  // }
  ///商品名稱
  Widget _goodsName(){
    // return Container(
    //   width: double.infinity,
    //   color:  Colors.white,
    //   height: AppSize.height(360),
    //   child:
    //     Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         Expanded(
    //           child: Container(
    //             padding: EdgeInsets.only(left: 15.0),
    //             child: Text(
    //               name,
    //               textAlign: TextAlign.left,
    //               maxLines: 1,
    //               style: ThemeTextStyle.personalShopNameStyle,
    //             ),
    //           ),
    //           flex: 1,
    //         ),
    //         Expanded(
    //           child: Container(
    //             padding: EdgeInsets.only(left: 15.0),
    //             child: Text(
    //               descript,
    //               textAlign: TextAlign.left,
    //               style: ThemeTextStyle.detailStyle,
    //             ),
    //           ),
    //           flex: 1,
    //         ),
    //         Expanded(
    //           child: Container(
    //             padding: EdgeInsets.only(left: 15.0),
    //             child:Text(
    //               "¥"+priceGoods.toStringAsFixed(2).toString(),
    //               textAlign: TextAlign.left,
    //               style: ThemeTextStyle.detailStylePrice,
    //             ),
    //           ),
    //           flex: 1,
    //         ),
    //         Container(
    //           width: double.infinity,
    //           height: AppSize.height(2),
    //           color: Colours.gray_f0,
    //         ),
    //         Expanded(
    //                child: Row(
    //                   children: <Widget>[
    //                               Expanded(
    //                                 child: Container(
    //                                   padding: EdgeInsets.only(left: 15.0),
    //                                   child: Text(
    //                                     '運費：免運費' ,
    //                                     textAlign: TextAlign.left,
    //                                     style: ThemeTextStyle.detailStyle
    //                                   ),
    //                                 ),
    //                                 flex: 1,
    //                               ),
    //                               Expanded(
    //                                 child: Container(
    //                                   padding: EdgeInsets.only(left: 15.0),
    //                                   child: Text(
    //                                     '剩餘：'+num.toString(),
    //                                     textAlign: TextAlign.left,
    //                                       style: ThemeTextStyle.detailStyle
    //                                   ),
    //                                 ),
    //                                 flex: 1,
    //                               )
    //
    //                   ],
    //                 ),flex: 1),
    //         Container(
    //           width: double.infinity,
    //           height: AppSize.height(2),
    //           color: Colours.gray_f0,
    //         ),
    //       ],
    //     )
    // );
  }

  ///查看商品評論
  Widget _goodsComment(){
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        title:  Text(
            '查看商品評論' ,
            textAlign: TextAlign.left,
            style: ThemeTextStyle.primaryStyle
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 17.0,
        ),
      ) ,
    );
  }

  StreamSubscription _selectSpecsSingleValueSubscription;
  StreamSubscription _selectSpecsMultiValueSubscription;
  void _listen() {
    _selectSpecsSingleValueSubscription = eventBus.on<SelectSpecsSingleValueEvent>().listen((SelectSpecsSingleValueEvent event) {
      int index = 0;
      if(event.localOwnSpecIndex != -1){
        _localOwnSpecList[event.localOwnSpecIndex] = event.value;
        String ownSpecString = '';
        _localOwnSpecList.forEach((v) {
          if(ownSpecString != ''){
            ownSpecString = ownSpecString + '_' + v;
          }
          else{
            ownSpecString = v;
          }
        });
        print(ownSpecString);
        for (WskuModel wSku in widget.skuModelLists) {
          if(wSku.indexes == ownSpecString){
            _skuModel = wSku;
            //index ++;
            eventBus.fire(SelectedSkuEvent(index,ownSpecMap));
            break;
          }
          index ++;
        }
      }
      ownSpecMap[event.key] = event.selectValue;
      //eventBus.fire(SelectedSkuEvent(index,ownSpecMap));
      if(event.globalOwnSpecIndex != -1){
        _globalOwnSpeclist[event.globalOwnSpecIndex] = event.value;
      }
    });

    _selectSpecsMultiValueSubscription = eventBus.on<SelectSpecsMultiValueEvent>().listen((SelectSpecsMultiValueEvent event) {
      ownSpecMap[event.key] = event.selectValue;
      if(event.localOwnSpecIndex != -1){
        List<String> multiValue = List<String>.generate(event.multiCount, (int index) => '0');
        for(String value in event.multiValue){
          multiValue[int.parse(value)] = '1';
        }
        String ownSpecString = '';
        multiValue.forEach((v) {
          ownSpecString = ownSpecString + v;
        });
        _localOwnSpecList[event.localOwnSpecIndex] = ownSpecString;
        ownSpecString = '';
        _localOwnSpecList.forEach((v) {
          if(ownSpecString != ''){
            ownSpecString = ownSpecString + '_' + v;
          }
          else{
            ownSpecString = v;
          }
        });

        int index = 0;
        _globalOwnSpecIndex = -1;
        _localOwnSpecIndex = -1;
        for (WskuModel wSku in widget.skuModelLists) {
          if(wSku.indexes == ownSpecString){
            _skuModel = wSku;
            eventBus.fire(SelectedSkuEvent(index,ownSpecMap));
            break;
          }
          index ++;
        }
      }

      if(event.globalOwnSpecIndex != -1){
        List<String> multiValue = List<String>.generate(event.multiCount, (int index) => '0');
        for(String value in event.multiValue){
          multiValue[int.parse(value)] = '1';
        }
        String ownSpecString = '';
        multiValue.forEach((v) {
          ownSpecString = ownSpecString + v;
        });
        _globalOwnSpeclist[event.globalOwnSpecIndex] = ownSpecString;
      }
    });
  }

}

void _checkOwnIndex(){

}
//flutter smart_select