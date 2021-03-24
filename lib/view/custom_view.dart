
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:jiwell_reservation/res/colours.dart';

import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/utils/image_utils.dart';
import 'package:jiwell_reservation/view/theme_ui.dart';


typedef ImgBtnFunc = void Function(String);

// ignore: must_be_immutable
class ImageButton extends StatelessWidget {
  double width;
  double height;
  double iconSize;
  Color iconColor;

  String assetPath;
  String text;

  TextStyle textStyle;
  ImgBtnFunc func;

  // ignore: sort_constructors_first
  ImageButton(this.assetPath,
      {this.width, this.height, this.iconSize, this.text, this.textStyle
      ,this.func});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>func(text),
      child: SizedBox(

        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage(assetPath),

                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(text, style: textStyle),
              )
            ]),
      ),
    );
  }
}

// ignore: must_be_immutable
class IconBtn extends StatelessWidget {
  double iconSize;
  Color iconColor;

  final IconData icon;
  String text;

  TextStyle textStyle;
  ImgBtnFunc func;

  // ignore: sort_constructors_first
  IconBtn(this.icon,
      {this.iconColor, this.text, this.textStyle
        ,this.func});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>func(text),
      child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon,color: iconColor),
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Text(text, style: textStyle),
              )
            ]),
    );
  }
}

/// 商品卡片

class ThemeCard extends StatelessWidget {
  final String title;
  final String price;
  final String number;
  final String imgUrl;
  final String descript;
  // ignore: sort_constructors_first
  const ThemeCard({
    this.title,
    this.price,
    this.number,
    this.imgUrl,
    this.descript
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: AppSize.height(268),
        decoration: ThemeDecoration.card2,
        child:
        Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child:  Container(
                    width: AppSize.height(600),
                    height: AppSize.height(232),
                    margin: const EdgeInsets.only(left: 15),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8)),
                      child: ImageUtils.getCachedNetworkImage(imgUrl,null,null)

                      // child:FadeInImage.assetNetwork(
                      //   placeholder: 'banner.jpg',
                      //   image:imgUrl,
                      //   fit: BoxFit.cover,)

                      // child:CachedNetworkImage(
                      //   imageUrl: imgUrl,
                      //   placeholder: (context, url) => Image.asset('images/default.png'),
                      //   errorWidget: (context, url, error) => new Icon(Icons.error),
                      //           fit: BoxFit.cover
                      // )
                      // child: Image.network(
                      //   imgUrl,
                      //   fit: BoxFit.cover,)
                      ,),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 20.0, top: 10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            style: ThemeTextStyle.cardTitleStyle,
                          ),
                          Text(
                            descript,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: ThemeTextStyle.cardNumStyle,
                          ),
                          Text(
                            price,
                            textAlign: TextAlign.left,
                            style: ThemeTextStyle.cardPriceStyle,
                          ),
                        ]
                    ),

                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Container(
                    alignment:Alignment.center,
                    height: AppSize.height(232),
                    child:Text(
                      number,
                      textAlign: TextAlign.center,
                      style: ThemeTextStyle.cardTitleStyle,
                    ),
                  ),
                  flex: 1,
                )
              ],
            ),
            Container(
              width: double.infinity,
              height: AppSize.height(2),
              color: Colours.gray_f5,
            )
          ],
        )

    );
  }
}
/// 商品卡片
typedef ClickCallback = void Function(String value);

class SpusThemeCard extends StatelessWidget {
  final String title;
  final String price;
  final String number;
  final String imgUrl;
  final String descript;
  final ClickCallback clickCallback;
  // ignore: sort_constructors_first
  const SpusThemeCard({
    this.title,
    this.price,
    this.number,
    this.imgUrl,
    this.descript,
    this.clickCallback
    });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      height: AppSize.height(320),
      decoration: ThemeDecoration.card2,
      child:
          Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child:  Container(
                      width: AppSize.height(600),
                      height: AppSize.height(232),
                      margin: const EdgeInsets.only(left: 15),
                      child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)),
                          child: ImageUtils.getCachedNetworkImage(imgUrl,BoxFit.cover,null),
                          // child: Image.network(
                          //   imgUrl,
                          //   fit: BoxFit.cover,
                          // ),
                      ),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20.0, top: 10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              style: ThemeTextStyle.cardTitleStyle,
                            ),
                            Text(
                              descript,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: ThemeTextStyle.cardNumStyle,
                            ),
                            Text(
                              price,
                              textAlign: TextAlign.left,
                              style: ThemeTextStyle.cardPriceStyle,
                            ),
                          ]
                      ),

                    ),
                    flex: 3,
                  ),
                  //activeMsg('滿100減10')
                  // Expanded(
                  //   child: Container(
                  //     alignment:Alignment.center,
                  //     height: AppSize.height(232),
                  //     child:Text(
                  //       number,
                  //       textAlign: TextAlign.center,
                  //       style: ThemeTextStyle.cardTitleStyle,
                  //     ),
                  //   ),
                  //   flex: 1,
                  // ),
                  Expanded(
                    child: Container(
                      alignment:Alignment.center,
                      height: AppSize.height(100),
                      child:activeMsg('滿100減10'),
                    ),
                    flex: 1,
                  ),
                ],
              ),
              _buildBottomBar(),
              Container(
                  width: double.infinity,
                  height: AppSize.height(6),
                  color: Colours.gray_f5,
              ),
            ],
          )
    );
  }

  //以下為評論分享讚使用
  Widget _buildBottomBar() {
    //return new BottomAppBar(
    const double leftOffset = 24.0;
    int _like = 0;
    int _commentsTotal = 0;
    return Container(
      margin: EdgeInsets.only(left: 20.0,right: 20.0),
      height: 30.0,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Stack(
            children: <Widget>[
              new Icon(
                Icons.thumb_up,
                size: 20.0,
                color: Colors.grey,
              ),
              new Container(
                margin: const EdgeInsets.only(left: leftOffset),
                child: new Text(
                  0 == _like ? '' : ('$_like'),
                  style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              )
            ],
          ),
          new InkWell(
            onTap: () {
              //_showBottomPop(context);
            },
            child: new Stack(
              children: <Widget>[
                new Icon(
                     Icons.share,
                     size: 20.0,
                     color: Colors.grey,
                ),
                new Container(
                  margin: const EdgeInsets.only(left: leftOffset),
                  child: new Text(
                    0 == _commentsTotal ? '' : ('$_commentsTotal'),
                    style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                )
              ],
            ),
            // child: new Icon(
            //   Icons.share,
            //   size: 20.0,
            //   color: Colors.grey,
            // ),
          ),
          new InkWell(
            onTap: () {
              //RouteUtil.route2Comment(context, widget.id);
              //Routes.instance.navigateTo(context, Routes.comment_page);
              clickCallback('comment_page');
            },
            child: new Stack(
              children: <Widget>[
                new Icon(
                  Icons.message,
                  size: 20.0,
                  color: Colors.grey,
                ),
                new Container(
                  margin: const EdgeInsets.only(left: leftOffset),
                  child: new Text(
                    0 == _commentsTotal ? '' : ('$_commentsTotal'),
                    style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
    //);
  }

  Widget activeMsg(String text) {
    return
      Container(
        height: 18,
        padding: EdgeInsets.symmetric(horizontal: 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: new BorderRadius.circular(2.0),
            color: Colours.lable_clour //rgba(255, 129, 2, 1)
        ),
        child: Text(
          text,
          style: TextStyle(
              color: Colours.white,
              fontSize: 8
          ),
        ),
      );
  }

  ///活动信息
  // Widget activeMsg(String text) {
  //   return text == null ? Container() : Positioned(
  //     right: 0,
  //     bottom: 5,
  //     child: Container(
  //       height: 16,
  //       padding: EdgeInsets.symmetric(horizontal: 4),
  //       alignment: Alignment.center,
  //       decoration: BoxDecoration(
  //           borderRadius: new BorderRadius.circular(2.0),
  //           color: Colours.lable_clour //rgba(255, 129, 2, 1)
  //       ),
  //       child: Text(
  //         text,
  //         style: TextStyle(
  //             color: Colours.white,
  //             fontSize: 8
  //         ),
  //       ),
  //     ),
  //
  //   );
  // }
}

/// 商品卡片

class BrandsThemeCard extends StatelessWidget {
  final String title;
  final String imgUrl;
  final String descript;
  final String price;
  final String number;
  // ignore: sort_constructors_first
  const BrandsThemeCard({
    this.title,
    this.imgUrl,
    this.descript,
    this.price,
    this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: AppSize.height(268),
        decoration: ThemeDecoration.card2,
        child:
        Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child:  Container(
                    width: AppSize.height(600),
                    height: AppSize.height(232),
                    margin: const EdgeInsets.only(left: 15),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8)),
                      child: ImageUtils.getCachedNetworkImage(imgUrl,BoxFit.cover,null),
                      // child: Image.network(
                      //   imgUrl,
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 20.0, top: 10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            style: ThemeTextStyle.cardTitleStyle,
                          ),
                          Text(
                            descript,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: ThemeTextStyle.cardNumStyle,
                          ),
                          Text(
                            price,
                            textAlign: TextAlign.left,
                            style: ThemeTextStyle.cardPriceStyle,
                          ),
                        ]
                    ),

                  ),
                  flex: 3,
                ),
                Expanded(
                  // child: Container(
                  //   alignment:Alignment.center,
                  //   //height: AppSize.height(248),
                  //   margin: const EdgeInsets.only(top: 10.0),
                  //   child:Text(
                  //     number,
                  //     textAlign: TextAlign.center,
                  //     //style: ThemeTextStyle.cardTitleStyle,
                  //       style: ThemeTextStyle.cardNumStyle
                  //   ),
                  // ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 20.0, top: 10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            number,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            style: ThemeTextStyle.cardTitleStyle,
                          ),
                          Text(
                            '',
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: ThemeTextStyle.cardNumStyle,
                          ),
                          Text(
                            '',
                            textAlign: TextAlign.left,
                            style: ThemeTextStyle.cardNumStyle,
                          ),
                        ]
                    ),

                  ),
                  flex: 1,
                )
              ],
            ),
            Container(
              width: double.infinity,
              height: AppSize.height(2),
              color: Colours.gray_f5,
            )
          ],
        )

    );
  }

}

class BrandsListViewThemeCard extends StatelessWidget {
  final String title;
  final String imgUrl;
  final String descript;
  // ignore: sort_constructors_first
  const BrandsListViewThemeCard({
    this.title,
    this.imgUrl,
    this.descript
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left:6,right: 6),
        width: ScreenUtil().screenWidth - AppSize.width(190),
        //width: double.infinity,
        height: double.infinity,
        decoration: ThemeDecoration.outlineCancelBtn1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child:  Container(
              width: AppSize.height(600),
              height: AppSize.height(232),
              margin: const EdgeInsets.only(left: 15),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8)),
                child: ImageUtils.getCachedNetworkImage(imgUrl,BoxFit.cover,null),
                // child: Image.network(
                //   imgUrl,
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 20.0, top: 10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      style: ThemeTextStyle.cardTitleStyle,
                    ),
                    Text(
                      descript,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: ThemeTextStyle.cardNumStyle,
                    ),
                    // Text(
                    //   price,
                    //   textAlign: TextAlign.left,
                    //   style: ThemeTextStyle.cardPriceStyle,
                    // ),
                  ]
              ),

            ),
            flex: 3,
          ),
          // Expanded(
          //   child: Container(
          //     alignment:Alignment.center,
          //     height: AppSize.height(232),
          //     child:Text(
          //       number,
          //       textAlign: TextAlign.center,
          //       style: ThemeTextStyle.cardTitleStyle,
          //     ),
          //   ),
          //   flex: 1,
          // )
        ],
      ),

    );
  }
}

class ThemeBtnCard extends StatelessWidget {
  final String title;
  final String price;
  final String imgUrl;

  // ignore: sort_constructors_first
  const ThemeBtnCard({
    this.title,
    this.price,
    this.imgUrl
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: AppSize.height(20)),
      decoration: ThemeDecoration.card2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8)),
              child: ImageUtils.getCachedNetworkImage(imgUrl,BoxFit.cover,null),
              // child:Image.network(
              //   imgUrl,
              //   fit: BoxFit.cover,
              // ),
          )
          ,
          Padding(
              child: Text(title,style: ThemeTextStyle.cardTitleStyle,
                maxLines:2,overflow: TextOverflow.clip,
              ),
              padding: EdgeInsets.all(AppSize.width(30))),
          Padding(
              padding: EdgeInsets.only(left: AppSize.width(30)),
              child:Text(price,style: ThemeTextStyle.cardPriceStyle)),
          Padding(
              padding: EdgeInsets.only(left: AppSize.width(30)),
              child:Image.asset('images/exchange_btn.png',fit: BoxFit.cover))
        ],
      ),
    );
  }
}

class Badge extends StatelessWidget {
  final String text;

  // ignore: sort_constructors_first
  const Badge(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 6),
      decoration: BoxDecoration(
        border: Border.all(color: ThemeColor.subTextColor),
        borderRadius: BorderRadius.circular(2)
      ),
      child: Text(text,style: TextStyle(
        fontSize: AppSize.sp(24),
        color: ThemeColor.hintTextColor
      ),),
    );
  }
}
class LoadingDialog extends Dialog {
  final String text;

  // ignore: sort_constructors_first
  const LoadingDialog({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: SizedBox(
          width: 120.0,
          height: 120.0,
          child: Container(
            decoration: const ShapeDecoration(
              color: Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: Text(text),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

