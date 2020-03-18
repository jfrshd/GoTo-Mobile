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

  void firebaseCloudMessagingListeners() {
	  if (Platform.isIOS) iOSPermission();

	  _firebaseMessaging.getToken().then((firebaseToken) async {
		  await SharedPreferencesHelper.setString(
			  Constants.firebaseToken, firebaseToken);
//      String authToken =
//          await SharedPreferencesHelper.getString(Constants.authToken);
		  store.dispatch(firebaseSetupAction(firebaseToken));
//      AccountService.updateFirebaseToken(authToken, firebaseToken);
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
