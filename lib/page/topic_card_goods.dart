import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jiwell_reservation/models/topic_goods_query_entity.dart';
import 'package:jiwell_reservation/routes/routes.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiwell_reservation/utils/image_utils.dart';

/**
 * 主题推荐
 */
class TopicCardGoods extends StatelessWidget {
  final List<TopicGoodsListModel> topicGoodsModleDataList;
  String imgUrl =
      "http://linjiashop-mobile-api.microapp.store/file/getImgStream?idFile=";

  TopicCardGoods({Key key, @required this.topicGoodsModleDataList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);

    return Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 5.0),
        padding: EdgeInsets.all(3.0),
        child: _buildWidget(context));
  }

  Row _buildRow(BuildContext context,
      List<TopicGoodsListModel> subTopicGoodsModleDataList) {
    List<Widget> mSubGoodsCard = [];
    Widget content;
    final screenWidth = ScreenUtil().screenWidth;

    for (int i = 0; i < subTopicGoodsModleDataList.length; i++) {
      String id=subTopicGoodsModleDataList[i].id;
      if (i == 0) {
        mSubGoodsCard.add(

          InkWell(
              onTap: () {
                onItemClick(context, i,id);
              },
              child: Container(
                width: AppSize.width(screenWidth / 2 - 21),
                height: AppSize.height(230),
                child: ImageUtils.getCachedNetworkImage("${subTopicGoodsModleDataList[0].topicGoodsModel.img}",BoxFit.cover,null),
                // child: CachedNetworkImage(
                //   placeholder: (context, url) => CircularProgressIndicator(),
                //   imageUrl: imgUrl + "${subTopicGoodsModleDataList[0].topicGoodsModel.img}",
                //   fit: BoxFit.fill,
                // ),
//                child: Image.network(
//                  imgUrl +
//                      "${subTopicGoodsModleDataList[0].topicGoodsModel.img}",
//                  fit: BoxFit.fill,
//                ),
              )),
        );
      } else {
        mSubGoodsCard.add(InkWell(
          onTap: () {
            onItemClick(context, i,id);
          },
          child: Container(
            width: AppSize.width(screenWidth / 4 - 30),
            height: AppSize.height(230),
            child:ImageUtils.getCachedNetworkImage((imgUrl + "${subTopicGoodsModleDataList[i].topicGoodsModel.img}"),BoxFit.cover,null),
            // child: Image.network(
            //   imgUrl + "${subTopicGoodsModleDataList[i].topicGoodsModel.img}",
            //   fit: BoxFit.fill,
            // ),
          ),
        ));
      }
    }

    content = Row(
      children: mSubGoodsCard,
    );
    return content;
  }

  void onItemClick(BuildContext context, int i,String id) {

    Map<String, String> p = {"id": id};
    Routes.instance.navigateToParams(context, Routes.topic_page, params: p);
  }

  Widget _buildWidget(BuildContext context) {
    List<Row> mTopCard = [];
    Widget content;
    List<TopicGoodsListModel> sub = List();
    for (int i = 0; i < topicGoodsModleDataList.length; i++) {
      if ((i + 1) % 3 == 1) {
        sub.add(topicGoodsModleDataList[i]);
        if (i == topicGoodsModleDataList.length - 1) {
          mTopCard.add(_buildRow(context, sub));
          sub.clear();
        }
      }
      if ((i + 1) % 3 == 2) {
        sub.add(topicGoodsModleDataList[i]);
        if (i == topicGoodsModleDataList.length - 1) {
          mTopCard.add(_buildRow(context, sub));
          sub.clear();
        }
      }
      if ((i + 1) % 3 == 0) {
        sub.add(topicGoodsModleDataList[i]);
        mTopCard.add(_buildRow(context, sub));
        sub.clear();
      }
    }

    content = Column(
      children: mTopCard,
    );
    return content;
  }
}
