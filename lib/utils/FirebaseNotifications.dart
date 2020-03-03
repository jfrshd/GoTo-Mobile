//import 'dart:io';
//
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:flutter_udid/flutter_udid.dart';
//
//class FirebaseNotifications {
//  BuildContext context;
//  FirebaseMessaging _firebaseMessaging;
//  Firestore firebaseFireStore;
//  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//  static final FirebaseNotifications _instance =
//      FirebaseNotifications._internal();
//
//  factory FirebaseNotifications() => _instance;
//
//  FirebaseNotifications._internal() {
//    _firebaseMessaging = FirebaseMessaging();
//    firebaseFireStore = Firestore.instance;
//
//    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//    var initializationSettingsAndroid =
//        new AndroidInitializationSettings("ic_notification");
//    var initializationSettingsIOS = new IOSInitializationSettings();
//    var initializationSettings = new InitializationSettings(
//        initializationSettingsAndroid, initializationSettingsIOS);
//    flutterLocalNotificationsPlugin.initialize(
//      initializationSettings,
//    );
//  }
//
//  void setUpFirebase() {
//    firebaseCloudMessaging_Listeners();
//    _saveDeviceToken();
//  }
//
//  void firebaseCloudMessaging_Listeners() {
//    if (Platform.isIOS) iOS_Permission();
//
//    _firebaseMessaging.getToken().then((token) {
//      print("Firebase Token: " + token);
//    });
//
//    _firebaseMessaging.configure(
//      onMessage: (Map<String, dynamic> message) async {
//        print('on message $message');
//        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//            'Goto', 'Goto Channel', 'Goto Notifications Channels',
//            importance: Importance.Max,
//            priority: Priority.High,
//            ticker: 'ticker');
//        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//        var platformChannelSpecifics = NotificationDetails(
//            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//        print(DateTime.now().millisecondsSinceEpoch);
//        await flutterLocalNotificationsPlugin.show(
//            (DateTime.now().millisecondsSinceEpoch / 10000000).truncate(),
//            message['notification']['title'],
//            message['notification']['body'],
//            platformChannelSpecifics);
//        /* showDialog(
//          context: context,
//          builder: (context) => AlertDialog(
//            content: ListTile(
//              title: Text(message['notification']['title']),
//              subtitle: Text(message['notification']['body']),
//            ),
//            actions: <Widget>[
//              FlatButton(
//                child: Text('Ok'),
//                onPressed: () => Navigator.of(context).pop(),
//              ),
//            ],
//          ),
//        );*/
//      },
//      onResume: (Map<String, dynamic> message) async {
//        print('on resume $message');
//      },
//      onLaunch: (Map<String, dynamic> message) async {
//        print('on launch $message');
//      },
//    );
//  }
//
//  _saveDeviceToken() async {
//    // Get the current user
//    String udid = await FlutterUdid.udid;
//
//    // FirebaseUser user = await _auth.currentUser();
//
//    // Get the token for this device
//    String fcmToken = await _firebaseMessaging.getToken();
//
//    // Save it to Firestore
//    if (fcmToken != null) {
//      var tokens = firebaseFireStore
//          .collection('users')
//          .document(udid)
//          .collection('tokens')
//          .document(fcmToken);
//
//      await tokens.setData({
//        'token': fcmToken,
//        'platform': Platform.operatingSystem,
//        'Time': DateTime.now().toString() // optional
//      });
//    }
//  }
//
//  void subscribeToTopic(String topic) {
//    _firebaseMessaging.subscribeToTopic(topic);
//  }
//
//  void unSubscribeFromTopic(String topic) {
//    _firebaseMessaging.unsubscribeFromTopic(topic);
//  }
//
//  void saveTopics(List<String> topics, String topicType) async {
//    String udid = await FlutterUdid.udid;
//
//    var tokens = firebaseFireStore
//        .collection('users')
//        .document(udid)
//        .collection('topics')
//        .document(topicType);
//
//    await tokens.setData({'topics': topics});
//  }
//
//  void iOS_Permission() {
//    _firebaseMessaging.requestNotificationPermissions(
//        IosNotificationSettings(sound: true, badge: true, alert: true));
//    _firebaseMessaging.onIosSettingsRegistered
//        .listen((IosNotificationSettings settings) {
//      print("Settings registered: $settings");
//    });
//  }
//
//  void checkFirestore(Function connected, Function notconnected) async {
//    try {
//      await firebaseFireStore
//          .runTransaction((Transaction tx) {})
//          .timeout(Duration(seconds: 5));
//      connected();
//    } catch (_) {
//      notconnected();
//    }
//  }
//}
