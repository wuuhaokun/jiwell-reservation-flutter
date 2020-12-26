import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:jiwell_reservation/dao/findings_dao.dart';
import 'package:jiwell_reservation/dao/hot_goods_dao.dart';
import 'package:jiwell_reservation/dao/new_goods_dao.dart';
import 'package:jiwell_reservation/dao/topic_query_dao.dart';
import 'package:jiwell_reservation/models/category_entity.dart';
import 'package:jiwell_reservation/models/hot_entity.dart';
import 'package:jiwell_reservation/models/topic_goods_query_entity.dart';
import 'package:jiwell_reservation/page/load_state_layout.dart';
import 'package:jiwell_reservation/page/subitem_goods.dart';
import 'package:jiwell_reservation/page/swiper_diy.dart';
import 'package:jiwell_reservation/page/topic_card_goods.dart';
import 'package:jiwell_reservation/res/colours.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/models/goods_entity.dart';
import 'package:jiwell_reservation/view/theme_ui.dart';

import '../../common.dart';

//LoadState _layoutState = LoadState.State_Loading;
/// 类别子页面
class FindingTabView extends StatefulWidget {
  final int currentPage;
  //final String id;
  //final List<String> ids;
  //final List<List<CategoryInfoModel>> categoryInfoModelss;

  final CategoryEntity categoryEntity;

  //final List<CategoryInfoModel> categoryInfoModels;

  /// 0,表示推荐
  /// 1，表示分类
  final HomeData topic;

  // ignore: sort_constructors_first
  const FindingTabView({this.currentPage,this.categoryEntity/*this.ids,this.categoryInfoModelss*/,@required this.topic});

  @override
  _FindingTabViewState createState() => _FindingTabViewState();
}

class _FindingTabViewState extends State<FindingTabView> with AutomaticKeepAliveClientMixin{
  final GlobalKey _headerKey = GlobalKey();
  final GlobalKey _footerKey = GlobalKey();
  LoadState _layoutState = LoadState.State_Loading;
  List<GoodsModel> goodsList = <GoodsModel>[];
  List<TopicGoodsListModel> topGoodsList = <TopicGoodsListModel>[];
  ///新品推荐
  List<GoodsModel> newGoodsList = <GoodsModel>[];
  ///热门推荐
  List<GoodsModel> hotGoodsList = <GoodsModel>[];

  List<List<GoodsModel>> mixGoodList = <List<GoodsModel>>[];

  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    if(widget.topic == HomeData.topic){
      loadTopicData();
    }
    if(widget.topic == HomeData.cateGory) {
      loadData();
    }
    super.initState();
  }

  /// 加载推荐数据
  // ignore: avoid_void_async
  void loadTopicData() async{
    final TopicGoodsQueryEntity entity = await TopicQueryDao.fetch();
    if(entity?.topicGoods !=null){
      if(mounted) {
        setState(() {
          topGoodsList.clear();
          topGoodsList = entity.topicGoods;
          _isLoading = false;
          if (topGoodsList.isNotEmpty) {
            _layoutState = LoadState.State_Success;
          }
          //loadHotData();//暫時先註解起來
          loadData();
        });
      }
    }else {

      setState(() {
        _layoutState = LoadState.State_Error;
      });
    }
  }
  // ignore: avoid_void_async
  void loadHotData() async{
    final HotEntity entity = await HotGoodsDao.fetch();
    if(entity?.goods != null){
      setState(() {
        hotGoodsList.clear();
        hotGoodsList = entity.goods;
        _isLoading = false;
        if (hotGoodsList.isNotEmpty) {
          _layoutState = LoadState.State_Success;
        }
        loadNewData();
      });
    }else{
      setState(() {
        _layoutState = LoadState.State_Error;
      });
    }
  }
  // ignore: avoid_void_async
  void loadNewData() async{
    final HotEntity entity = await NewGoodsDao.fetch();
    if(entity?.goods != null){
      setState(() {
        newGoodsList.clear();
        newGoodsList = entity.goods;
        _isLoading = false;
        if (newGoodsList.isNotEmpty) {
          _layoutState = LoadState.State_Success;
        }
      });
    }else{
      setState(() {
        _layoutState = LoadState.State_Error;
      });
    }
  }

  /// 加载分类数据
  // ignore: avoid_void_async
  void loadData() async{

    mixGoodList.clear();
    for(CategoryModel model in widget.categoryEntity.category){
      final GoodsEntity entity = await FindingsDao.fetch(model.id.toString());
      if (entity?.goods != null) {
        if(entity.goods.isNotEmpty) {
          mixGoodList.add(entity?.goods);
        }
      } else {
        setState(() {
          _layoutState = LoadState.State_Error;
        });
        return;
      }
    }
    _layoutState = LoadState.State_Empty;
    if(mixGoodList.isNotEmpty){
      setState(() {
        _isLoading = false;
        _layoutState = LoadState.State_Success;
      });
    }
  }

  Widget _getHotData(){
    return hotGoodsList.isNotEmpty?
    Container(
      child: Column(
        children: <Widget>[
          Container(
              color: Colours.white,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10),
              height: AppSize.height(94),
              padding: const EdgeInsets.only(left: 10,top: 7),
              child:  Text('热门推荐',
                style: ThemeTextStyle.orderFormTitleStyle,)
          ),
          ThemeView.divider(),
          SubItemGoods(goodsModleDataList: hotGoodsList)
        ],
      ),
    ):Container();

  }

  Widget _getNewData(){
    return newGoodsList.isNotEmpty?
    Container(
      child: Column(
        children: <Widget>[
          Container(
              color: Colours.white,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10),
              height: AppSize.height(94),
              padding: const EdgeInsets.only(left: 10,top: 7),
              child:  Text('新品推荐',
                style: ThemeTextStyle.orderFormTitleStyle,)
          ),
          ThemeView.divider(),
          SubItemGoods(goodsModleDataList: newGoodsList)
        ],
      ),
    ):Container();
  }

  Widget _gethasTitleData(List<GoodsModel> googlist, String title){
    return googlist.isNotEmpty?
    Container(
      child: Column(
        children: <Widget>[
          Container(
              color: Colours.white,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10),
              height: AppSize.height(94),
              padding: const EdgeInsets.only(left: 10,top: 7),
              child:  Text(title,
                style: ThemeTextStyle.orderFormTitleStyle,)
          ),
          ThemeView.divider(),
          SubItemGoods(goodsModleDataList: googlist)
        ],
      ),
    ):Container();

  }

  List<Widget> _getWidgetList(){
    if(!mixGoodList.isNotEmpty){
      // ignore: always_specify_types
      return [];
    }
    final List<Widget> widgetList = <Widget>[];
    final CategoryModel model = widget.categoryEntity.category[0];
    widgetList.add(SwiperDiy(swiperDataList:model.categoryInfoModels, width:double.infinity,height: AppSize.height(430)));

    int index = 0;
    for(List<GoodsModel> list in mixGoodList){
      if(list.isEmpty){
        continue;
      }
      final CategoryModel model = widget.categoryEntity.category[index];
      final String topic = model.name;
      if(list.isNotEmpty) {
        widgetList.add(_gethasTitleData(list, topic));
      }
      index ++;
    }
    return widgetList;
  }

  // ignore: missing_return
  Widget _getHomeDataType(){
    ///返回推荐数据
    if(widget.topic == HomeData.topic){
      return ListView(
        children: <Widget>[
          // ignore: prefer_if_elements_to_conditional_expressions
          (topGoodsList.isNotEmpty ? TopicCardGoods(topicGoodsModleDataList: topGoodsList):Container()),
          _getHotData(),
          _getNewData()

        ],
      );
    }

    ///返回项目数据
    if(widget.topic == HomeData.cateGory){
      return ListView(
          children: _getWidgetList()
      );
    }
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
            child:_getHomeDataType(),
            onRefresh: () async {
              _isLoading = true;
              if(widget.topic == HomeData.topic){
                loadTopicData();
              }
              if(widget.topic == HomeData.cateGory){
                loadData();
              }
            },
            onLoad: () async {
              await Future.delayed(Duration(seconds: 2), () {//這個要放著不然看不到轉圈圈
              });
            }
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return
      LoadStateLayout(
          state: _layoutState,
          errorRetry: () {
            setState(() {
              _layoutState = LoadState.State_Loading;
            });
            if(widget.topic==HomeData.topic){
              loadTopicData();
            }
            if(widget.topic==HomeData.cateGory){
              loadData();
            }

          }, //错误按钮点击过后进行重新加载
          successWidget:_getContent()
      );

  }
  @override
  bool get wantKeepAlive => true;
}