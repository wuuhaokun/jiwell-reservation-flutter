
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSize{
  static void init(BuildContext context){
    //ScreenUtil.init(designSize:Size(1080, 1920), allowFontScaling:true);
    //ScreenUtil.init(context);
    ScreenUtil.init(context, designSize: Size(1080, 1920), allowFontScaling: false);
  }

  static double height(double value){
    return ScreenUtil().setHeight(value);
  }

  static double width(double value){
    return ScreenUtil().setWidth(value);
  }

  static double sp(double value){
    return ScreenUtil().setSp(value);
  }
}


