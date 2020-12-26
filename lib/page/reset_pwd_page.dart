import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jiwell_reservation/dao/sendsms_dao.dart';
import 'package:jiwell_reservation/receiver/event_bus.dart';
import 'package:jiwell_reservation/res/colours.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/utils/dialog_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiwell_reservation/utils/expression_utils.dart';
/// 可用時使用的字體樣式。
final TextStyle _availableStyle = TextStyle(
  fontSize: 16.0,
  color:Colours.blue_1,
);

/// 不可用時使用的樣式。
final TextStyle _unavailableStyle = TextStyle(
  fontSize: 16.0,
  color: Colours.text_gray,
);
class ResetCodePage extends StatefulWidget {
  /// 倒計時的秒數，默認60秒。
  final int countdown;
  /// 用戶點擊時的回調函數。
  final Function onTapCallback;
  /// 是否可以獲取驗證碼，默認為`false`。
  final bool available;
  String phoneNum;
  ResetCodePage({
    this.countdown: 60,
    this.onTapCallback,
    this.available: true,
    @required this.phoneNum,
  });
  @override
  _ResetCodePageState createState() => _ResetCodePageState();
}
class _ResetCodePageState extends State<ResetCodePage> {
  /// 倒計時的計時器。
  Timer _timer;
  /// 當前倒計時的秒數。
  int _seconds;
  /// 當前墨水瓶（`InkWell`）的字體樣式。
  TextStyle inkWellStyle = _availableStyle;
  /// 當前墨水瓶（`InkWell`）的文本。
  String _verifyStr = '獲取驗證碼';
  bool isCheck=false;


  @override
  void initState() {
    super.initState();
    _seconds = widget.countdown;
  }
  StreamSubscription _phoneSubscription;
  /// 監聽Bus events
  void _listen() {
    _phoneSubscription= eventBus.on<UserNumInEvent>().listen((event) {
      setState(() {
        widget.phoneNum=event.num;
      });
    });
  }
  /// 啟動倒計時的計時器。
  void _startTimer() {
    // 計時器（`Timer`）組件的定期（`periodic`）構造函數，創建一個新的重複計時器。
    _timer = Timer.periodic(
        Duration(seconds: 1),
            (timer) {
          if (_seconds == 0) {
            _cancelTimer();
            _seconds = widget.countdown;
            inkWellStyle = _availableStyle;
            setState(() {});
            return;
          }
          _seconds--;
          _verifyStr = '已發送$_seconds'+'s';
          if(mounted) {
            setState(() {});
            if (_seconds == 0) {
              isCheck=false;
              _verifyStr = '重新發送';
            }
          }
        });
  }

  /// 取消倒計時的計時器。
  void _cancelTimer() {
    /// 計時器（`Timer`）組件的取消（`cancel`）方法，取消計時器。
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    _listen();
    ///墨水瓶（`InkWell`）組件，響應觸摸的矩形區域。
    return widget.available ? InkWell(
        child: Text(
          ' $_verifyStr ',
          style: inkWellStyle,
        ),
        onTap: () {
          if(widget.phoneNum==null||widget.phoneNum.isEmpty){
            Fluttertoast.showToast(
                fontSize:AppSize.sp(20),
                gravity: ToastGravity.CENTER,
                msg: '請輸入手機號碼~');
            return ;
          }
          if(!ExpressionUtils.isPhone(widget.phoneNum)){
            Fluttertoast.showToast(
                fontSize:AppSize.sp(20),
                gravity: ToastGravity.CENTER,
                msg: '手機號碼格式不正確~');
            return ;
          }
          if(_seconds == widget.countdown&&!isCheck){
            // widget.onTapCallback();
            isCheck=true;
            sendSms(widget.phoneNum);
          }

        }
    ): InkWell(
      child: Text(
        ' 獲取驗證碼 ',
        style: _unavailableStyle,
      ),
    );
  }

  void sendSms(String mobile) async{
    FocusScope.of(context).requestFocus(FocusNode());
    bool entity = await SendSmsDao.fetch(mobile);
    if(entity!=null && entity == true) {
      _startTimer();
      inkWellStyle = _unavailableStyle;
      _verifyStr = '已發送$_seconds' + 's';
      //ToastUtil.buildToast('短信驗證碼為:'+entity.msgModel.data);
      setState(() {});
      widget.onTapCallback();
    }else{
      ToastUtil.buildToast('發送失敗');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _cancelTimer();
    _phoneSubscription.cancel();
  }

}