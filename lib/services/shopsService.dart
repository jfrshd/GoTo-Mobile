import 'dart:async';

import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/utils/SharedPreferencesHelper.dart';
import 'package:http/http.dart' as http;

import '../api.dart';
import 'authService.dart';

Future<http.Response> getShop(int shopID) async {
  String token = await getAuthToken();
  final accountID =
      (await SharedPreferencesHelper.getInt(Constants.accountID)).toString();
  return http.get(API.shopsAPI + "/" + shopID.toString() + "/" + accountID,
      headers: {"Authorization": token}).timeout(Duration(seconds: 2));
}

Future<http.Response> toggleFollowShop(int shopID, bool isFollowed) async {
  String token = await getAuthToken();
  return http.post(isFollowed ? API.unFollowShop : API.followShop, headers: {
    "Authorization": token
  }, body: {
    "account_id":
        (await SharedPreferencesHelper.getInt(Constants.accountID)).toString(),
    "shop_id": shopID.toString()
  }).timeout(Duration(seconds: 2));
}
