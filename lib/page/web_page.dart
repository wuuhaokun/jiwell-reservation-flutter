import 'package:flutter/material.dart';
import 'package:jiwell_reservation/utils/app_size.dart';
import 'package:jiwell_reservation/view/app_topbar.dart';
import 'package:jiwell_reservation/view/customize_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';
// ignore: must_be_immutable
class WebViewPage extends StatefulWidget {
  String url;

  // ignore: sort_constructors_first
  WebViewPage({this.url});
  @override
  _WebViewState createState() => _WebViewState();
}
class _WebViewState extends State<WebViewPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);

    return Scaffold(
        appBar: MyAppBar(
        preferredSize: Size.fromHeight(AppSize.height(160)),
    child:CommonBackTopBar(title: '網頁',onBack:()=>Navigator.pop(context)),
    ),
      body: Stack(
        children: <Widget>[
          WebView(
            initialUrl: widget.url,
            onWebViewCreated: (WebViewController web) {
              web.canGoBack().then((bool res) {
//                print(res); // 是否能返回上一级
              });
              web.currentUrl().then((String url) {
//                print(url); // 返回当前url
              });
              web.canGoForward().then((bool res) {
//                print(res); //是否能前进
              });
            },
            onPageFinished: (String value) {
              // 返回当前url
//              print(value);
              setState(() {
                _isLoading = false;
              });
            },
          ),
          _loading()
        ],
      ),
    );
  }

  StatelessWidget _loading() {
    return _isLoading == true
        ? Container(
      decoration: BoxDecoration(color: Colors.white),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    )
        : const Text('');
  }
}