import 'dart:async';

import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/utils/SharedPreferencesHelper.dart';
import 'package:http/http.dart' as http;

import '../api.dart';
import 'authService.dart';

Future<http.Response> getRegions() async {
  String token = await getAuthToken();

  return http.get(API.regionsAPI,
      headers: {"Authorization": token}).timeout(Duration(seconds: 2));
}

Future<http.Response> updateSelectedRegions(List<int> ids) async {
  String authToken = await getAuthToken();
  return http.post(API.updateSelectedRegions, headers: {
    "Authorization": authToken
  }, body: {
    "account_id":
        (await SharedPreferencesHelper.getInt(Constants.accountID)).toString(),
    "region_ids[]": ids.toString(),
  }).timeout(Duration(seconds: 2));
}
