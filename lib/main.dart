
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiwell_reservation/utils/config.dart';
import 'package:jiwell_reservation/utils/fcm_push.dart';
import 'package:jiwell_reservation/utils/connectivity_utils.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'page/index_page.dart';

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 10000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());

  });
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }
  FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
}

class MyApp extends StatelessWidget {

  MyApp() : super(){
    //ConnectivityUtils.initConnectivityUtils();
  }
  @override
  Widget build(BuildContext context) {
    if(ENABLE_DEBUG_MODEL == false) {
      _clearPreferences();
    }
    if(ENABLE_FCM_PUSH_NOTIFCATION) {
      FcmNotification.getInstance().initPush(context); //推播功能
    }
   return MaterialApp(
                  //        debugShowCheckedModeBanner: false,
                  home: IndexPage(),
                  theme: ThemeData(
                      primarySwatch: Colors.blue
                  ),
                  builder: (BuildContext context, Widget child) {
                  /// make sure that loading can be displayed in front of all other widgets
                  return FlutterEasyLoading(child: child);
     },
            );
  }
  //一打開後清空相關設定 如token 要要求重新登入
  // ignore: always_declare_return_types
  _clearPreferences() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

}
/*
class _PageDemoState extends State<PageDemo> {
  StreamSubscription<ConnectivityResult> subscription;
  String nowNetWork="";
  @override
  initState() {
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      if (result == ConnectivityResult.mobile) {
        // I am connected to a mobile network.
        setState(() {
          this.nowNetWork='当前处于移动网络';
        });
      } else if (result == ConnectivityResult.wifi) {
        // I am connected to a wifi network.
        setState(() {
          this.nowNetWork='当前处于wifi';
        });

      }else{
        setState(() {
          this.nowNetWork='网络无连接';
        });

      }
    });
  }
 */


/*
import 'package:connectivity/connectivity.dart';

///2019.4.18 By GX
///判断网络是否可用
///0 - none | 1 - mobile | 2 - WIFI
Future<int> isNetWorkAvailable() async{
  var connectivityResult = await (new Connectivity().checkConnectivity());

  if (connectivityResult == ConnectivityResult.mobile)
    return 1;
  else if (connectivityResult == ConnectivityResult.wifi)
    return 2;
  else if (connectivityResult == ConnectivityResult.none)
    return 0;
}
 */
//Android推播參考 https://medium.com/@lucysdad/flutter-firebase-cloud-message-5f886f1cea49
//IOS 推播參考

// returnList = [
// {'name': "選擇縣市(必填)", 'value': ''},
// {'name': "台北", 'value': "01"},
// {'name': "新北市", 'value': "02"},
// {'name': "基隆", 'value': "03"},
// {'name': "桃園", 'value': "04"},
// {'name': "新竹", 'value': "05"},
// {'name': "苗栗", 'value': "06"},
// {'name': "台中", 'value': "07"},
// {'name': "彰化", 'value': "08"},
// {'name': "南投", 'value': "09"},
// {'name': "雲林", 'value': "10"},
// {'name': "嘉義", 'value': "11"},
// {'name': "台南", 'value': "12"},
// {'name': "高雄", 'value': "13"},
// {'name': "屏東", 'value': "14"},
// {'name': "宜蘭", 'value': "15"},
// {'name': "花蓮", 'value': "16"},
// {'name': "板橋", 'value': "18"},
// {'name': "新莊", 'value': "19"},
// {'name': "土城", 'value': "20"},
// {'name': "中和", 'value': "21"},
// {'name': "台東", 'value': "22"}
// ];