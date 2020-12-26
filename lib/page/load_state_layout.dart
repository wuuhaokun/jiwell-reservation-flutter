
import 'package:flutter/material.dart';
///四種視圖狀態
enum LoadState { State_Success, State_Error, State_Loading, State_Empty }

///根據不同狀態來展示不同的視圖
class LoadStateLayout extends StatefulWidget {

  final LoadState state; //頁面狀態
  final Widget successWidget;//成功視圖
  final VoidCallback errorRetry; //錯誤事件處理

  // ignore: sort_constructors_first
  const LoadStateLayout(
      {Key key,
        this.state = LoadState.State_Loading,//默認為加載狀態
        this.successWidget,
        this.errorRetry})
      : super(key: key);

  @override
  _LoadStateLayoutState createState() => _LoadStateLayoutState();
}

class _LoadStateLayoutState extends State<LoadStateLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //寬高都充滿屏幕剩餘空間
      width: double.infinity,
      height: double.infinity,
      child: _buildWidget,
    );
  }

  ///根據不同狀態來顯示不同的視圖
  Widget get _buildWidget {
    switch (widget.state) {
      case LoadState.State_Success:
        return widget.successWidget;
        break;
      case LoadState.State_Error:
        return _errorView;
        break;
      case LoadState.State_Loading:
        return _loadingView;
        break;
      case LoadState.State_Empty:
        return _emptyView;
        break;
      default:
        return null;
    }
  }

  ///加載中視圖
  Widget get _loadingView {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: Colors.transparent),
      alignment: Alignment.center,
      child: Container(
        height: 80,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Color(0x88000000), borderRadius: BorderRadius.circular(6)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[CircularProgressIndicator(), Text('正在加載')],
        ),
      ),
    );
  }

  ///錯誤視圖
  Widget get _errorView {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'images/load_error_view.png',
            height: 80,
            width: 100,
          ),
          Text("加載失敗，請重試"),
          RaisedButton(
            color: Color(0xffbc2929),
            onPressed: widget.errorRetry,
            child: Text(
              '重新加載',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  ///數據為空的視圖
  Widget get _emptyView {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'images/ic_empty.png',
            height: 100,
            width: 100,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text('暫無數據'),
          )
        ],
      ),
    );
  }
}