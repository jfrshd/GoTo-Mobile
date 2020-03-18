import 'dart:async';

import 'package:http/http.dart' as http;

import '../api.dart';

class CategoriesService {
  static Future<http.Response> fetchCategories(String token) async {
    print("fetchCategories: " +
        (token.length > 0 ? token.substring(0, 50) : 'empty'));
    return http.get(API.categoriesAPI,
        headers: {"Authorization": token}).timeout(Duration(seconds: 2));
  }

  static Future<http.Response> updateSelectedCategories(
      String token, int accountID, List<int> ids) async {
    return http.post(API.updateSelectedCategories, headers: {
      "Authorization": token
    }, body: {
      "account_id": accountID,
      "category_ids[]": ids.toString(),
    }).timeout(Duration(seconds: 2));
  }
}
