import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../common.dart';

class FcmNotification {

  static FcmNotification _instance;
  //final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  // ignore: always_specify_types
  StreamSubscription iosSubscription;

  String fcmToken = '';

  static FcmNotification getInstance() {
    _instance ??= FcmNotification();
    _instance._fcm.requestNotificationPermissions();
    _instance._fcm.configure();
    return _instance;
  }

  void initPush(BuildContext context){
    fcmSubscribe('TopicToListen');
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        print(data);
        _saveDeviceToken();
      });

      _fcm.requestNotificationPermissions(const IosNotificationSettings());
    } else {
      _saveDeviceToken();
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        // final snackbar = SnackBar(
        //   content: Text(message['notification']['title']),
        //   action: SnackBarAction(
        //     label: 'Go',
        //     onPressed: () => null,
        //   ),
        // );

        // Scaffold.of(context).showSnackBar(snackbar);
        if (context != null) {
          showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  content: ListTile(
                    title: Text(message['notification']['title']),
                    subtitle: Text(message['notification']['body']),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      color: Colors.amber,
                      child: const Text('Ok'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
          );
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        // ignore: flutter_style_todos
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        // ignore: flutter_style_todos
        // TODO optional
      },
    );
  }

  /// Get the token, save it to the database for current user
  // ignore: always_declare_return_types
  _saveDeviceToken() async {
    // Get the current user
    //String uid = 'jeffd23';
    // FirebaseUser user = await _auth.currentUser();
    // Get the token for this device
    fcmToken = await _fcm.getToken();
    print('fcmToken: $fcmToken');

    // Save it to Firestore
    // if (fcmToken != null) {
    //   final tokens = _db
    //       .collection('users')
    //       .doc(uid)
    //       .collection('tokens')
    //       .doc(fcmToken);
    //
    //   await tokens.set({
    //     'token': fcmToken,
    //     'createdAt': FieldValue.serverTimestamp(), // optional
    //     'platform': Platform.operatingSystem // optional
    //   });
    //}
  }

  // Subscribe the user to a topic
  _subscribeToTopic() async {
    // Subscribe the user to a topic
    _fcm.subscribeToTopic('puppies');
  }

  void dispose() {
    if (iosSubscription != null) iosSubscription.cancel();
  }

  void fcmSubscribe(String topic) {
    _fcm.subscribeToTopic(topic);
  }

  void fcmUnSubscribe(String topic) {
    _fcm.unsubscribeFromTopic(topic);
  }

}