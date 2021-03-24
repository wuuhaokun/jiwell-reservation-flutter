import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jiwell_reservation/dao/classify_dao.dart';
import 'package:jiwell_reservation/page/load_state_layout.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/view/app_topbar.dart';
import 'package:jiwell_reservation/view/customize_appbar.dart';
import 'package:jiwell_reservation/view/theme_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClassifyPage extends StatefulWidget {
  const ClassifyPage({Key key}) : super(key: key);

  @override
  _ClassifyPageState createState() => _ClassifyPageState();
}

class _ClassifyPageState extends State<ClassifyPage> with AutomaticKeepAliveClientMixin<ClassifyPage> {
  @override
  bool get wantKeepAlive => true;
  LoadState _layoutState = LoadState.State_Loading;

  List<ClassifyEntity> classifyList = <ClassifyEntity>[]; // 分类列表

  //List<Tab> myTabs = <Tab>[];
  //List<FindingTabView> bodys = [];
  //TabController mController;
  //HomeData topicData = HomeData.topic;
  //HomeData cateGoryData = HomeData.cateGory;
  //LoadState _layoutState = LoadState.State_Loading;
  double width=0;

  @override
  Future<void> initState(){
    super.initState();
    loadCateGoryData();
  }

  int _selectedIndex = 0; // 选择的分类索引
  int bottomNavIndex = 1;
  bool loading = false;

  // ignore: avoid_void_async
  void loadCateGoryData() async {
    final Classify entity = await ClassifyDao.fetch();
    if (entity?.category.isNotEmpty) {
      setState(() {
        classifyList = entity.category;
        loading = true;
        _layoutState = LoadState.State_Success;
      });
    }
    else{
      setState(() {
        _layoutState = LoadState.State_Error;
      });
    }
  }

  Widget ClassifyUI() {
    return Row(children: <Widget>[
            // 左侧导航分类列表
            Container(
                width: 100.0,
                height: MediaQuery.of(context).size.height,
                color: Colors.grey[100],
                child: ListView.builder(
                  itemCount: (classifyList.isNotEmpty?classifyList.length:0),
                  itemBuilder: (BuildContext context, int index) {
                    // 当前选中项
                    bool flag = false;
                    if (_selectedIndex == index) {
                      flag = true;
                    }
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      child: Container(
                        color: flag ? Colors.green[50] : Colors.grey[100],
                        height: 44.0,
                        child: Center(
                          child: Text((classifyList.isNotEmpty?classifyList[index].classifyName:''),
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: flag
                                      ? Theme.of(context).primaryColor
                                      : Colors.black)),
                        ),
                      ),
                    );
                  },
                )),
            // 子分类列表
            Container(
                    width: MediaQuery.of(context).size.width - 100.0,
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height,
                    child: CustomScrollView(shrinkWrap: true, slivers: <Widget>[
                      SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 0.0,
                          crossAxisSpacing: 0.0,
                          childAspectRatio: 1,
                        ),
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int subIndex) {
                          // // 路由传递参数
                          // Map<String,dynamic> params;
                          // var params = new Map<String,dynamic>();
//                          var params = classifyList[_selectedIndex]
//                                  .children[subIndex]
//                                  .classifyName +
//                              classifyList[_selectedIndex]
//                                  .children[subIndex]
//                                  .id
//                                  .toString();
                          return new Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(top: 5.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                InkWell(
                                  onTap: () => {
                                    //kun 先移除
                                    //Application.router.navigateTo(context,
                                    //    "/productList/${Uri.encodeComponent(params)}")
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      CachedNetworkImage(
                                        width: 50.0,
                                        fit: BoxFit.contain,
                                        imageUrl: (classifyList.isNotEmpty?"http://47.107.101.76/" + classifyList[_selectedIndex].children[subIndex].img:''),
                                        placeholder: (context, url) => new Icon(
                                          Icons.image,
                                          color: Colors.grey[300],
                                          size: 50.0,
                                        ),
                                        errorWidget: (context, url, error) => new Icon(
                                          Icons.image,
                                          color: Colors.grey[300],
                                          size: 50.0,
                                        ),
                                      ),
                                      Text((classifyList.isNotEmpty?classifyList[_selectedIndex]
                                          .children[subIndex]
                                          .classifyName:''))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                            childCount: (classifyList.isNotEmpty?classifyList[_selectedIndex].children.length:0)),
                      )
                    ]))
//                : Container()
          ]);
//        : Center(
//            child: !loading
//                ? const CircularProgressIndicator(
//                    strokeWidth: 2,
//                  )
//                : Container(
//                    width: 110.0,
//                    height: 36.0,
//                    decoration: BoxDecoration(
//                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                      border: Border.all(color: Colors.grey[400]),
//                    ),
//                    child: InkWell(
//                      child: const Center(
//                        child: Text(
//                          '重试',
//                          style: TextStyle(fontSize: 14.0),
//                        ),
//                      ),
//                      onTap: () {
//                        // 获取分类列表数据
//                        //kun 先移除
////                        getCategoryList().then((data) {
////                          Classify list = Classify.fromJson(data);
////                          List<ClassifyData> showData = <ClassifyData>[];
////                          list.data.forEach((v) => {showData.add(v)});
////                          setState(() {
////                            classifyList = list.data;
////                          });
////                        });
//                      },
//                    ),
//                  ),
//          );
  }

  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        centerTitle: true,
//        elevation: 0,
//        title: Text(
//          '分类',
//          style: TextStyle(color: Colors.white),
//        ),
//      ),
//      body: ClassifyUI(),
//    );
//  }
  Widget build(BuildContext context) {
    super.build(context);
    AppSize.init(context);
    final screenWidth = ScreenUtil().screenWidth;
//    if(myTabs.isNotEmpty) {
//      width=(screenWidth / (myTabs.length*2))  - 45;
//    }
    return Scaffold(
        appBar: MyAppBar(
          preferredSize: Size.fromHeight(AppSize.height(160)),
          child: CommonTopBar(title: "天下電通系統"),
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
                  height: 0/*MediaQuery.of(context).size.height*/,
                  child: Row(children: <Widget>[
                  ],),
                ),
                Expanded(
                  child: ClassifyUI()
                ),
              ],
            ),
          ),
        )
    );

  }
}

//class ClassifyPage extends StatefulWidget {
//  const ClassifyPage({Key key}) : super(key: key);
//
//  @override
//  _ClassifyPageState createState() => _ClassifyPageState();
//}
//
//class _ClassifyPageState extends State<ClassifyPage> with AutomaticKeepAliveClientMixin<ClassifyPage> {
//  @override
//  bool get wantKeepAlive => true;
//  LoadState _layoutState = LoadState.State_Loading;
//
//  List<ClassifyEntity> classifyList = <ClassifyEntity>[]; // 分类列表
//
//  @override
//  Future<void> initState(){
//    loadCateGoryData();
//    super.initState();
//  }
//
//  int _selectedIndex = 0; // 选择的分类索引
//  int bottomNavIndex = 1;
//  bool loading = false;
//
//  // ignore: avoid_void_async
//  void loadCateGoryData() async {
//    final Classify entity = await ClassifyDao.fetch();
//    if (entity?.category != null) {
//      setState(() {
//        classifyList = entity.category;
//        loading = true;
//      });
//    }
//  }
//
//  Widget ClassifyUI() {
//    return classifyList.isNotEmpty
//        ? Row(children: <Widget>[
//      // 左侧导航分类列表
//      Container(
//          width: 100.0,
//          height: MediaQuery.of(context).size.height,
//          color: Colors.grey[100],
//          child: ListView.builder(
//            itemCount: classifyList.length,
//            itemBuilder: (BuildContext context, int index) {
//              // 当前选中项
//              bool flag = false;
//              if (_selectedIndex == index) {
//                flag = true;
//              }
//              return InkWell(
//                onTap: () {
//                  setState(() {
//                    _selectedIndex = index;
//                  });
//                },
//                child: Container(
//                  color: flag ? Colors.green[50] : Colors.grey[100],
//                  height: 44.0,
//                  child: Center(
//                    child: Text(classifyList[index].classifyName,
//                        style: TextStyle(
//                            fontSize: 16.0,
//                            color: flag
//                                ? Theme.of(context).primaryColor
//                                : Colors.black)),
//                  ),
//                ),
//              );
//            },
//          )),
//      // 子分类列表
//      (classifyList.isNotEmpty &&
//          classifyList[_selectedIndex].children.length > 0)
//          ? Container(
//          width: MediaQuery.of(context).size.width - 100.0,
//          color: Colors.white,
//          height: MediaQuery.of(context).size.height,
//          child: CustomScrollView(shrinkWrap: true, slivers: <Widget>[
//            SliverGrid(
//              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                crossAxisCount: 3,
//                mainAxisSpacing: 0.0,
//                crossAxisSpacing: 0.0,
//                childAspectRatio: 1,
//              ),
//              delegate: SliverChildBuilderDelegate(
//                      (BuildContext context, int subIndex) {
//                    // // 路由传递参数
//                    // Map<String,dynamic> params;
//                    // var params = new Map<String,dynamic>();
//                    var params = classifyList[_selectedIndex]
//                        .children[subIndex]
//                        .classifyName +
//                        classifyList[_selectedIndex]
//                            .children[subIndex]
//                            .id
//                            .toString();
//                    // params['name'] = classifyList[_selectedIndex].children[subIndex].classifyName;
//                    // params['id'] = classifyList[_selectedIndex].children[subIndex].id;
//                    return new Container(
//                      color: Colors.white,
//                      padding: EdgeInsets.only(top: 5.0),
//                      child: new Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceAround,
//                        children: <Widget>[
//                          InkWell(
//                            onTap: () => {
//                              //kun 先移除
//                              //Application.router.navigateTo(context,
//                              //    "/productList/${Uri.encodeComponent(params)}")
//                            },
//                            child: Column(
//                              children: <Widget>[
//                                CachedNetworkImage(
//                                  width: 50.0,
//                                  fit: BoxFit.contain,
//                                  imageUrl: "http://47.107.101.76/" + classifyList[_selectedIndex].children[subIndex].img,
//                                  placeholder: (context, url) => new Icon(
//                                    Icons.image,
//                                    color: Colors.grey[300],
//                                    size: 50.0,
//                                  ),
//                                  errorWidget: (context, url, error) => new Icon(
//                                    Icons.image,
//                                    color: Colors.grey[300],
//                                    size: 50.0,
//                                  ),
//                                ),
//                                Text(classifyList[_selectedIndex]
//                                    .children[subIndex]
//                                    .classifyName)
//                              ],
//                            ),
//                          ),
//                        ],
//                      ),
//                    );
//                  },
//                  childCount:
//                  classifyList[_selectedIndex].children.length),
//            )
//          ]))
//          : Container()
//    ])
//        : Center(
//      child: !loading
//          ? const CircularProgressIndicator(
//        strokeWidth: 2,
//      )
//          : Container(
//        width: 110.0,
//        height: 36.0,
//        decoration: BoxDecoration(
//          borderRadius: BorderRadius.all(Radius.circular(20.0)),
//          border: Border.all(color: Colors.grey[400]),
//        ),
//        child: InkWell(
//          child: const Center(
//            child: Text(
//              '重试',
//              style: TextStyle(fontSize: 14.0),
//            ),
//          ),
//          onTap: () {
//            // 获取分类列表数据
//            //kun 先移除
////                        getCategoryList().then((data) {
////                          Classify list = Classify.fromJson(data);
////                          List<ClassifyData> showData = <ClassifyData>[];
////                          list.data.forEach((v) => {showData.add(v)});
////                          setState(() {
////                            classifyList = list.data;
////                          });
////                        });
//          },
//        ),
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        centerTitle: true,
//        elevation: 0,
//        title: Text(
//          '分类',
//          style: TextStyle(color: Colors.white),
//        ),
//      ),
//      body: ClassifyUI(),
//    );
//  }
//}
