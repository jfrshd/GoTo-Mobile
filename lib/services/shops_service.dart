import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

import '../api.dart';

class ShopsService {
  static Future<http.Response> getShop(
      String token, int accountID, int shopID) async {
    return retry(
      // Make a GET request
      () => http.get(
          API.shopsAPI + "/" + shopID.toString() + "/" + accountID.toString(),
          headers: {"Authorization": token}).timeout(Duration(seconds: 5)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
  }

  static Future<http.Response> searchShops(
      String token, String searchText) async {
	  return retry(
		  // Make a GET request
			  () =>
			  http.get(API.searchShops + "/" + searchText,
				  headers: {"Authorization": token}).timeout(
				  Duration(seconds: 5)),
		  // Retry on SocketException or TimeoutException
		  retryIf: (e) => e is SocketException || e is TimeoutException,
	  );
  }

  static Future<http.Response> toggleFollowShop(
      String token, int accountID, int shopID, bool isFollowed) async {
	  return retry(
		  // Make a GET request
			  () =>
			  http.post(
				  isFollowed ? API.unFollowShop : API.followShop, headers: {
				  "Authorization": token
			  }, body: {
				  "account_id": accountID.toString(),
				  "shop_id": shopID.toString()
			  }).timeout(Duration(seconds: 5)),
		  // Retry on SocketException or TimeoutException
		  retryIf: (e) => e is SocketException || e is TimeoutException,
	  );
  }
}
