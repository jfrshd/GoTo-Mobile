import 'dart:async';

import 'package:gotomobile/api.dart';
import 'package:http/http.dart' as http;

class RegionsService {
  static Future<http.Response> fetchRegions(String token) async {
    return http.get(API.regionsAPI,
        headers: {"Authorization": token}).timeout(Duration(seconds: 2));
  }

  static Future<http.Response> updateSelectedRegions(
      String token, int accountID, List<int> ids) async {
    return http.post(API.updateSelectedRegions, headers: {
      "Authorization": token
    }, body: {
      "account_id": accountID.toString(),
      "region_ids[]": ids.toString(),
    }).timeout(Duration(seconds: 2));
  }
}
