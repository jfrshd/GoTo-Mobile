import 'dart:async';

import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/utils/SharedPreferencesHelper.dart';
import 'package:http/http.dart' as http;

import '../api.dart';
import 'authService.dart';

Future<http.Response> getCategories() async {
  String token = await getAuthToken();

  return http.get(API.categoriesAPI,
      headers: {"Authorization": token}).timeout(Duration(seconds: 2));
}

Future<http.Response> updateSelectedCategories(List<int> ids) async {
  String authToken = await getAuthToken();

  print({
    "account_id":
        (await SharedPreferencesHelper.getInt(Constants.accountID)).toString(),
    "category_ids[]": ids.toString(),
  });
  return http.post(API.updateSelectedCategories, headers: {
    "Authorization": authToken
  }, body: {
    "account_id":
        (await SharedPreferencesHelper.getInt(Constants.accountID)).toString(),
    "category_ids[]": ids.toString(),
  }).timeout(Duration(seconds: 2));
}
