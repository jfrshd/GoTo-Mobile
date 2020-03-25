import 'dart:async';

import 'package:http/http.dart' as http;

import '../api.dart';

class ShopsService {
  static Future<http.Response> getShop(
      String token, int accountID, int shopID) async {
    return http.get(
        API.shopsAPI + "/" + shopID.toString() + "/" + accountID.toString(),
        headers: {"Authorization": token}).timeout(Duration(seconds: 2));
  }

  static Future<http.Response> searchShops(
      String token, String searchText) async {
    return http.get(API.searchShops + "/" + searchText,
        headers: {"Authorization": token}).timeout(Duration(seconds: 5));
  }

  static Future<http.Response> toggleFollowShop(
      String token, int accountID, int shopID, bool isFollowed) async {
    return http.post(isFollowed ? API.unFollowShop : API.followShop, headers: {
      "Authorization": token
    }, body: {
      "account_id": accountID.toString(),
      "shop_id": shopID.toString()
    }).timeout(Duration(seconds: 2));
  }
}
