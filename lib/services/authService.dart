import 'dart:async';
import 'dart:convert';

import 'package:gotomobile/api.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/utils/SharedPreferencesHelper.dart';
import 'package:http/http.dart' as http;

Future<String> getAuthToken() async {
  String authToken =
      await SharedPreferencesHelper.getString(Constants.authToken);

  if (authToken != "") {
    print("JWT-Token from SharedPreferences: " +
        authToken.substring(0, 50) +
        "...");
    return authToken;
  } else {
    print('Fetching token...');
    try {
      http.Response authResponse = await http.post(API.signIn, body: {
        "email": Constants.authEmail,
        "password": Constants.authPassword,
        "remember_me": "true"
      }).timeout(const Duration(seconds: 2));

      if (authResponse.statusCode == 200) {
        String accessToken = json.decode(authResponse.body)["success"]["token"];

        await SharedPreferencesHelper.setString(
          Constants.authToken,
          accessToken,
        );
        print("Fetched token: " + accessToken.substring(0, 50) + '...');
        return accessToken;
      } else if (authResponse.statusCode == 401) {
        print("Error fetching token");
      }
      return "";
    } on Exception catch (e) {
      print('getAuthToken error: ');
      print(e);
      return "";
    }
  }
}

Future<String> updateFirebaseToken(String firebaseToken) async {
  try {
    String authToken = await getAuthToken();

    http.Response response = await http.post(API.publishToken, headers: {
      "Authorization": authToken
    }, body: {
      "firebase_token": firebaseToken,
    }).timeout(const Duration(seconds: 2));

    final parsed = Map<String, dynamic>.from(json.decode(response.body));
    if (parsed['status'] == 'success') {
      await SharedPreferencesHelper.setInt(
          Constants.accountID, parsed["account_id"]);
      return 'success';
    } else if (parsed['status'] == 'fail') {
      await SharedPreferencesHelper.setInt(
          Constants.accountID, parsed["account_id"]);
      return 'FirebaseToken already exist!';
    }
  } on Exception catch (e) {
    print('getAuthToken error: ');
    print(e);
    return "";
  }
}
