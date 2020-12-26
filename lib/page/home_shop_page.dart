import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:jiwell_reservation/common.dart';
import 'package:jiwell_reservation/dao/new/buy_type_dao.dart';
import 'package:jiwell_reservation/models/new/buy_type_entity.dart';
import 'package:jiwell_reservation/page/load_state_layout.dart';
import 'package:jiwell_reservation/res/colours.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/utils/connectivity_utils.dart';
import 'package:jiwell_reservation/utils/dialog_utils.dart';
import 'package:jiwell_reservation/view/app_topbar.dart';
import 'package:jiwell_reservation/view/customize_appbar.dart';
import 'package:jiwell_reservation/view/new/brand_finding_tabview.dart';
import 'package:jiwell_reservation/view/new/check_update.dart';
import 'package:jiwell_reservation/view/theme_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// app 首页

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  List<Tab> myTabs = <Tab>[];
  // ignore: always_specify_types
  List<BrandFindingTabView> bodys = [];
  TabController mController;
  HomeData topicData = HomeData.topic;
  HomeData cateGoryData = HomeData.cateGory;
  LoadState _layoutState = LoadState.State_Loading;
  double width = 0;

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
        child: CommonTopBar(title: '格上租車'),
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
    //CheckUpdate().check(context);
    ConnectivityUtils.initConnectivityUtils().then((value){
      if(ConnectivityUtils.connectStatus == ConnectivityResult.none){
        ToastUtil.buildToast('沒有網絡,請打開網路後再試！！');
        _layoutState = LoadState.State_Error;
        setState(() {
        });
        //return;
      }
    });
    loadCateGoryData();
  }
  // 加载大类列表和标签
  // ignore: avoid_void_async
  void loadCateGoryData() async {
    final BuyTypeEntity entity = await BuyTypeDao.fetch();
    if (entity?.buyTypeModelList != null) {
      final List<Tab> myTabsTmp = <Tab>[];
      //myTabsTmp.add(Tab(text:'推薦'));
      // ignore: always_specify_types
      final List<BrandFindingTabView> bodysTmp = [];
      for (int i = 0; i < entity.buyTypeModelList.length; i++) {
        final BuyTypeModel model = entity.buyTypeModelList[i];
        myTabsTmp.add(Tab(text: model.name));
        bodysTmp.add(BrandFindingTabView(
              currentPage: i, buyTypemodel: model, topic: cateGoryData));
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