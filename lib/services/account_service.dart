import 'dart:async';

import 'package:gotomobile/api.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:http/http.dart' as http;

class AccountService {
  static Future<http.Response> getAuthToken() async {
    return http.post(API.login, body: {
      "email": Constants.authEmail,
      "password": Constants.authPassword,
      "remember_me": "true"
    }).timeout(const Duration(seconds: 2));
  }

  static Future<http.Response> updateFirebaseToken(
      String authToken, String firebaseToken) async {
    return http.post(API.publishToken, headers: {
      "Authorization": authToken
    }, body: {
      "firebase_token": firebaseToken,
    }).timeout(const Duration(seconds: 2));
  }
}
