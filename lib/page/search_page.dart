import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiwell_reservation/dao/hot_goods_dao.dart';
import 'package:jiwell_reservation/dao/search_dao.dart';
import 'package:jiwell_reservation/models/hot_entity.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:jiwell_reservation/view/customize_appbar.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import '../models/goods_entity.dart';
import '../utils/app_size.dart';
import '../view/app_topbar.dart';
import 'card_goods.dart';
import 'load_state_layout.dart';
import 'package:jiwell_reservation/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget{
  @override
  _SearchPageState createState() => _SearchPageState();
}
class _SearchPageState extends State<SearchPage>  with AutomaticKeepAliveClientMixin ,
    SingleTickerProviderStateMixin{
  LoadState _layoutState = LoadState.State_Loading;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  List<GoodsModel> goodsList = <GoodsModel>[];
//  String imgUrl = 'http://linjiashop-mobile-api.microapp.store/file/getImgStream?idFile=';
  @override
  Widget build(BuildContext context) {
    super.build(context);
    AppSize.init(context);

    return Scaffold(
        appBar: MyAppBar(
          preferredSize: Size.fromHeight(AppSize.height(160)),
          // ignore: missing_return
          child: SearchBar(focusNode: _focusNode,controller:_controller,  onChangedCallback: () {
            final String key = _controller.text;
            if (key.isEmpty) {
              loadData();
            }else {
              _doSearch(key.toString());
            }
          }),

        ),
        body:
        LoadStateLayout(
            state: _layoutState,
            errorRetry: () {
              setState(() {
                _layoutState = LoadState.State_Loading;
              });
              _isLoading=true;
              final String key = _controller.text;
              if (key.isEmpty) {
                loadData();
              }else {
                _doSearch(key.toString());
              }

            }, //错误按钮点击过后进行重新加载
            successWidget:_getContent()
        )
    );
  }
  final GlobalKey _headerKey = GlobalKey();
  final GlobalKey _footerKey = GlobalKey();

  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    loadData();
    super.initState();
  }
  // ignore: avoid_void_async
  void _doSearch(String key) async{
    _isLoading = true;
    final SearchEntity entity = await SearchDao.fetch(key,'token');
    if(entity?.goods != null){
      setState(() {
        goodsList.clear();
        goodsList = entity.goods;
        _isLoading = false;
        if (goodsList.isNotEmpty) {
          _layoutState = LoadState.State_Success;
        } else {
          _layoutState = LoadState.State_Empty;
        }
      });
    }else{
      setState(() {
        _layoutState = LoadState.State_Error;
      });
    }
  }

  /// 加载热门商品

  // ignore: avoid_void_async
  void loadData() async{
    setState(() {
      _isLoading = false;
      _layoutState = LoadState.State_Empty;
      goodsList.clear();
    });
    return;
//    final HotEntity entity = await HotGoodsDao.fetch();
//    if(entity?.goods != null){
//        setState(() {
//          goodsList.clear();
//          goodsList = entity.goods;
//          _isLoading = false;
//          if (goodsList.isNotEmpty) {
//            _layoutState = LoadState.State_Success;
//          } else {
//            _layoutState = LoadState.State_Empty;
//          }
//        });
//    }else{
//        setState(() {
//          _layoutState = LoadState.State_Error;
//        });
//    }
  }

 Widget _getContent(){
    if(_isLoading){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }else{
      return Container(
        padding: EdgeInsets.only(
            top: AppSize.width(30),
            left: AppSize.width(30),
            right: AppSize.width(30)),
        child: EasyRefresh(
            header: MaterialHeader(
              key: _headerKey,
            ),
            footer: MaterialFooter(
              key: _footerKey,
            ),

            child:SingleChildScrollView(

                child:CardGoods(goodsModleDataList:goodsList)

            ),
            onRefresh: () async {
              _isLoading = true;
              final String name = _controller.text;
              if (name.isEmpty) {
                loadData();
              }else {
                _doSearch(name.toString());
              }

            },
            onLoad: ()  async {
              await Future.delayed(Duration(seconds: 2), () {//這個要放著不然看不到轉圈圈
              });
            }
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}