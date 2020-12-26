
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageUtils{

  // static Widget getCachedNetworkImage(String imgUrl, BoxFit fit , String defaultImage){
  //   return CachedNetworkImage(
  //       imageUrl: '',//imgUrl,
  //       placeholder: (context, url) => Image.asset((defaultImage??'images/default.png')),
  //       //errorWidget: (context, url, error) => new Icon(Icons.error),
  //       fit: (fit??BoxFit.cover)
  //   );
  // }


static Widget getCachedNetworkImage(String imgUrl, BoxFit fit , String defaultImage){
  return Image.asset('images/default.png');
}
}


