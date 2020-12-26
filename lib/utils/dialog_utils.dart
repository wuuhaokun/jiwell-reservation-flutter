
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'app_size.dart';
class ToastUtil {
  static void buildToast(String str) {
    Fluttertoast.showToast(
        fontSize: 13,//不要用App.Size(13)
        gravity: ToastGravity.CENTER,
        msg: str);

//    //Kun 修正如下
//    Fluttertoast.showToast(
//        msg: str,
//        toastLength: Toast.LENGTH_SHORT,
//        fontSize: 13,//AppSize.sp(16.0),
//        gravity: ToastGravity.CENTER,
//        timeInSecForIosWeb: 1,
////        backgroundColor: Colors.red,
////        textColor: Colors.white
//    );
  }
}

class DialogUtils{
  static showDialog(BuildContext cxt, String title, String content,
      ok(), cancel()) {
    showCupertinoDialog<int>(
        context: cxt,
        builder: (cxt) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("確定"),
                onPressed: () {
                  ok();
                },
              ),
              CupertinoDialogAction(
                child: Text("取消"),
                onPressed: () {
                  cancel();
                },
              )
            ],
          );
        });
  }
  static showOneDialog(BuildContext cxt, String title, String content,
      ok()) {
    showCupertinoDialog<int>(
        context: cxt,
        builder: (cxt) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("確定"),
                onPressed: () {
                  ok();
                },
              )
            ],
          );
        });
  }
}
