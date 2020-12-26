
import 'dart:ui';
import 'dart:io' as rental;
import 'dart:isolate';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiwell_reservation/dao/new/version_update_dao.dart';
import 'package:jiwell_reservation/models/new/version_update_entity.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:store_redirect/store_redirect.dart';

ReceivePort _port = ReceivePort();

class AppInfo {
  AppInfo();

  String version;

  AppInfo.fromJson(Map<String, dynamic> json) : version = json['version'];
}

class CheckUpdate {
  VersionUpdateEntity versionUpdateEntity;
  static String _downloadPath = '';
  static String _filename = 'YOUR_APP.apk';
  static String _taskId = '';

  Future<bool> showInstallUpdateDialog(BuildContext context, String updateForce) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("檢測到新版本"),
          content: Text("已準備好更新，確認安裝新版本?"),
          actions: <Widget>[
            FlatButton(
                child: Text(
                  "取消",
                  style: TextStyle(color: Color(0xff999999)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                } // 關閉對話框
            ),
            FlatButton(
              child: Text("更新"),
              onPressed: () {
                StoreRedirect.redirect(
                                   androidAppId:
                                       versionUpdateEntity.versionUpdateModel.androidAppId,
                                   iOSAppId: versionUpdateEntity.versionUpdateModel.iOSAppId);
                //關閉對話框並返回true
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Future check(BuildContext context) async {
    bool hasNewVersion = false;//await _checkVersion();
    print("hasNewVersion");
    if (!hasNewVersion) {
      print(hasNewVersion);
      return hasNewVersion;
    }
    showInstallUpdateDialog(
        context, '');
    // showInstallUpdateDialog(
    //     context, (versionUpdateEntity.versionUpdateModel.force_update??false));
  }

  // 下载前的准备
  static Future<void> _prepareDownload() async {
    // _downloadPath = (await _findLocalPath()) + '/Download';
    // final savedDir = rental.Directory(_downloadPath);
    // bool hasExisted = await savedDir.exists();
    // if (!hasExisted) {
    //   savedDir.create();
    // }
    // print('--------------------downloadPath: $_downloadPath');
  }

  // 获取下载地址
  static Future<String> _findLocalPath() async {
    final directory = rental.Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // 检查版本
  Future<bool> _checkVersion() async {
    versionUpdateEntity = await VersionUpdateDao.fetch();
    if (versionUpdateEntity != null) {
      // 获取 PackageInfo class
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String localVesrion = packageInfo.version.replaceAll(".", '');
      String remoteVesrion =
          versionUpdateEntity.versionUpdateModel.iosVersion.replaceAll(".", '');
      if (rental.Platform.isAndroid) {
        remoteVesrion = versionUpdateEntity.versionUpdateModel.androidVersion
            .replaceAll(".", '');
      }
      if (int.parse(localVesrion) >= int.parse(remoteVesrion)) {
        return false;
      }
      return true;
    }
    return false;
  }
}
