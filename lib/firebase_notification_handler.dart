import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gotomobile/main.dart';
import 'package:gotomobile/redux/actions/account_actions.dart';
import 'package:gotomobile/utils/SharedPreferencesHelper.dart';

import 'utils/Constants.dart';

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;

  void setUpFirebase() {
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessagingListeners();
  }

  Future<void> firebaseCloudMessagingListeners() async {
    if (Platform.isIOS) iOSPermission();
    store.dispatch(LoadingFirebaseAction());
    int accountID = await SharedPreferencesHelper.getInt(Constants.accountID);
    if (accountID != -1)
      store.dispatch(firebaseSetupAction(true, accountID: accountID));

    _firebaseMessaging.getToken().then((firebaseToken) async {
      await SharedPreferencesHelper.setString(
          Constants.firebaseToken, firebaseToken);
      store.dispatch(firebaseSetupAction(false, firebaseToken: firebaseToken));
    }).catchError((error) {
      print("firebase error:");
      print(error);
      store.dispatch(ErrorFirebaseAction);
    });

//    _firebaseMessaging.configure(
//      onMessage: (Map<String, dynamic> message) async {
//        print('on message $message');
//      },
//      onResume: (Map<String, dynamic> message) async {
//        print('on resume $message');
//      },
//      onLaunch: (Map<String, dynamic> message) async {
//        print('on launch $message');
//      },
//    );
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}
