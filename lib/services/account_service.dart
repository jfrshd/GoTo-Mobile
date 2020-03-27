import 'dart:async';
import 'dart:io';

import 'package:gotomobile/api.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

class AccountService {
  static Future<http.Response> getAuthToken() async {
    return retry(
      // Make a GET request
      () => http.post(API.login, body: {
        "email": Constants.authEmail,
        "password": Constants.authPassword,
        "remember_me": "true"
      }).timeout(const Duration(seconds: 5)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
  }

  static Future<http.Response> updateFirebaseToken(
      String authToken, String firebaseToken) async {
	  return retry(
		  // Make a GET request
			  () =>
			  http.post(API.publishToken, headers: {
				  "Authorization": authToken
			  }, body: {
				  "firebase_token": firebaseToken,
			  }).timeout(const Duration(seconds: 5)),
		  // Retry on SocketException or TimeoutException
		  retryIf: (e) => e is SocketException || e is TimeoutException,
	  );
  }
}
