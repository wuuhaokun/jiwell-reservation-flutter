import 'package:flutter/material.dart';
import 'package:jiwell_reservation/common.dart';
import 'package:jiwell_reservation/models/new/spus_entity.dart';
import 'package:jiwell_reservation/page/load_state_layout.dart';

import 'package:jiwell_reservation/res/colours.dart';
import 'package:jiwell_reservation/dao/findings_dao.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/view/app_topbar.dart';
import 'package:jiwell_reservation/view/customize_appbar.dart';
import 'package:jiwell_reservation/view/new/spu_finding_tabview.dart';
import 'package:jiwell_reservation/view/theme_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'card_goods.dart';
import 'dart:convert';

/// app 項目顯示主頁

class ProductItemsPage extends StatefulWidget {
  final String name;
  final String id;
  final String incategory;
  const ProductItemsPage({this.name,this.id,this.incategory});
  @override
  _ProductItemsPageState createState() => _ProductItemsPageState();
}

class _ProductItemsPageState extends State<ProductItemsPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  List<Tab> myTabs = <Tab>[];
  // ignore: always_specify_types
  List<SpuFindingTabView> bodys = [];
  TabController mController;
  HomeData topicData = HomeData.topic;
  HomeData cateGoryData = HomeData.cateGory;
  LoadState _layoutState = LoadState.State_Loading;
  double width = 0;

  List<List<IncategoryModel>>incategoryList = [];

  ///返回不同头部
  Widget _getHeader() {
      return CommonBackTopBar(
          title: widget.name + '-品項', onBack: () => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    AppSize.init(context);
    final double screenWidth = ScreenUtil().screenWidth;
    if(myTabs.isNotEmpty) {
      width=(screenWidth / (myTabs.length*2))  - 45;
    }
    return Scaffold(
      appBar: MyAppBar(
        preferredSize: Size.fromHeight(AppSize.height(160)),
        child: _getHeader(),

      ),
      body:
      LoadStateLayout(
        state: _layoutState,
        errorRetry: () {
          setState(() {
            _layoutState = LoadState.State_Loading;
          });
          loadCateGoryData();
        },
        successWidget: Container(
          color: ThemeColor.appBg,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                height: AppSize.height(120),
                child: Row(children: <Widget>[
                  Expanded(
                    child: TabBar(
                      isScrollable: true,
                      controller: mController,
                      labelColor: Colours.lable_clour,
                      indicatorColor: Colours.lable_clour,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 1.0,
                      unselectedLabelColor: const Color(0xff333333),
                      labelStyle: TextStyle(fontSize: AppSize.sp(44)),
                      indicatorPadding: EdgeInsets.only(
                          left: AppSize.width(width), right: AppSize.width(width)),
                      labelPadding: EdgeInsets.only(
                          left: AppSize.width(width), right: AppSize.width(width)),
                      tabs: myTabs,
                    ),
                  ),
                ],),
              ),
              Expanded(
                child: TabBarView(
                  controller: mController,
                  children: bodys,
                ),
              ),

            ],
          ),
        ),
      )
    );

  }

  @override
  void initState() {
    super.initState();
    loadCateGoryData();
  }
  // 加载大类列表和标签
  // ignore: avoid_void_async
  void loadCateGoryData() async {
    final SpusEntity entity = await FindingsSpuDao.fetch(widget.id);
    if (entity?.spusModelList!= null) {
      Map<String, dynamic> user = jsonDecode(widget.incategory);
      List<IncategoryModel> incategoryModelList = [];
      user.forEach((k, v){
        IncategoryModel incategoryModel = IncategoryModel();
        incategoryModel.spusModellList = [];
        List<SpusModel> list = [];
        for(SpusModel spusModel in entity.spusModelList){
          if(spusModel.internalCategoryId.toString() == k) {
            list.add(spusModel);
          }
        }
        incategoryModel.incategoryName = v;
        incategoryModel.spusModellList = list;
        incategoryModelList.add(incategoryModel);
      });
      incategoryList.add(incategoryModelList);

      print(user);
      print(widget.incategory);

      final List<Tab> myTabsTmp = <Tab>[];
      final List<SpuFindingTabView> bodysTmp = [];
      int index = 0;
      List<IncategoryModel> localIncategoryModelList = [];
       for (List<IncategoryModel> incategoryModelList in incategoryList ) {
         if(index == 0) {
           myTabsTmp.add(Tab(text: incategoryModelList[0].incategoryName));
           bodysTmp.add(SpuFindingTabView(
               currentPage: index,
               incategoryList: incategoryList[0],
               topic: cateGoryData));
           localIncategoryModelList = incategoryModelList;
         }
         index ++;
       }

       for(int i = 1; i < localIncategoryModelList.length;i ++){
         List<IncategoryModel> list = [];
         IncategoryModel incategoryModel = localIncategoryModelList[i];
         list.add(incategoryModel);
         myTabsTmp.add(Tab(text: incategoryModel.incategoryName));
         bodysTmp.add(SpuFindingTabView(
             currentPage: i,
             incategoryList: list,
             topic: cateGoryData));
       }
       setState(() {
         myTabs.addAll(myTabsTmp);
         bodys.addAll(bodysTmp);
         mController = TabController(
           length: myTabs.length,
           vsync: this,
         );
         _layoutState = LoadState.State_Success;
       });
    }else{
      setState(() {
        _layoutState = LoadState.State_Error;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if(null!=mController) {
      mController.dispose();
    }
  }

  @override
  bool get wantKeepAlive => true;

}
