import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:jiwell_reservation/dao/topic_details_dao.dart';

import 'package:jiwell_reservation/models/topic_details_entity.dart';

import 'package:jiwell_reservation/page/load_state_layout.dart';
import 'package:jiwell_reservation/page/topic_deatails_goods.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/view/app_topbar.dart';
import 'package:jiwell_reservation/view/customize_appbar.dart';
import 'package:jiwell_reservation/view/theme_ui.dart';
import 'package:flutter_html/flutter_html.dart';
///
/// 推薦詳情頁
///
class TopicDetails extends StatefulWidget {
  final String id;

  TopicDetails({this.id});

  @override
  _TopicDetailsState createState() => _TopicDetailsState();
}

class _TopicDetailsState extends State<TopicDetails> {
  final String imgUrl =
      "http://linjiashop-mobile-api.microapp.store/file/getImgStream?idFile=";
  LoadState _loadStateDetails = LoadState.State_Loading;
  TopicDetailsEntity topicDetailsEntity;

  @override
  void initState() {
    if (mounted) loadData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadData() async {
    TopicDetailsEntity entity =
        await TopicDetailsDao.fetch(widget.id.toString());
    if (entity != null) {
      setState(() {
        topicDetailsEntity = entity;
        _loadStateDetails = LoadState.State_Success;
      });
    } else {
      setState(() {
        _loadStateDetails = LoadState.State_Error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    return Scaffold(
        appBar: MyAppBar(
          preferredSize: Size.fromHeight(AppSize.height(160)),
          child: _getHeader(),
        ),
        body: LoadStateLayout(
            state: _loadStateDetails,
            errorRetry: () {
              setState(() {
                _loadStateDetails = LoadState.State_Loading;
              });
              loadData();
            },
            successWidget: _getContent()));
  }

  ///返回不同頭部
  Widget _getHeader() {
    if (null == topicDetailsEntity) {
      return CommonBackTopBar(
          title: "詳情", onBack: () => Navigator.pop(context));
    } else {
      return CommonBackTopBar(
          title: topicDetailsEntity.articleModel.title,
          onBack: () => Navigator.pop(context));
    }
  }

  ///返回内容
  Widget _getContent() {
    if (null == topicDetailsEntity || topicDetailsEntity.goodsList == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: AppSize.height(94),
            child: Text(
              topicDetailsEntity.articleModel.title,
              textAlign: TextAlign.center,
              style: ThemeTextStyle.personalShopNameStyle,
            ),
          ),
          Html(data: topicDetailsEntity.articleModel.content),
          TopicDeatilsCardGoods(topicGoods: topicDetailsEntity.goodsList)
        ],
      );
    }
  }

}
