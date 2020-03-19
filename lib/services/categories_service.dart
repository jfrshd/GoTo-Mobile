import 'dart:async';

import 'package:gotomobile/api.dart';
import 'package:http/http.dart' as http;

class CategoriesService {
  static Future<http.Response> fetchCategories(String token) async {
    return http.get(API.categoriesAPI,
        headers: {"Authorization": token}).timeout(Duration(seconds: 2));
  }

  static Future<http.Response> updateSelectedCategories(
      String token, int accountID, List<int> ids) async {
    return http.post(API.updateSelectedCategories, headers: {
      "Authorization": token
    }, body: {
      "account_id": accountID.toString(),
      "category_ids[]": ids.toString(),
    }).timeout(Duration(seconds: 2));
  }
}
