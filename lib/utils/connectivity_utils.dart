
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'dialog_utils.dart';

class ConnectivityUtils {
  static StreamSubscription<ConnectivityResult> subscription;
  static ConnectivityResult connectStatus = ConnectivityResult.none;

  static Future<void> initConnectivityUtils() async {
    // ignore: avoid_as
    connectStatus =  await ConnectivityUtils.isNetWorkAvailable();
    if(connectStatus == ConnectivityResult.none){
      ToastUtil.buildToast('網絡無法連接！');
    }
    connectListen();
  }

  static void connectListen() {
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      connectStatus = result;
      // Got a new connectivity status!
      // if (result == ConnectivityResult.mobile) {
      //   // I am connected to a mobile network.
      //   nowNetWork = '當前處於移動網絡';
      //   connectStatus = 1;
      // } else if (result == ConnectivityResult.wifi) {
      //   // I am connected to a wifi network.
      //   connectStatus = 2;
      //   nowNetWork = '當前處於wifi';
      // } else {
      //   nowNetWork = '網絡無法連接';
      //   ToastUtil.buildToast('網絡無法連接！');
      //   connectStatus = 0;
      // }
    });
  }

  static Future<ConnectivityResult> isNetWorkAvailable() async{
    // ignore: unnecessary_parenthesis
    final ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult;
    // if (connectivityResult == ConnectivityResult.mobile)
    //   return ConnectivityResult.mobile;
    // else if (connectivityResult == ConnectivityResult.wifi)
    //   return ConnectivityResult.wifi;
    // else if (connectivityResult == ConnectivityResult.none)
    //   return 0;
  }

  void dispose() {
    subscription.cancel();
  }
}
