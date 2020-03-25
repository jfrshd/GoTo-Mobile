import 'dart:async';

import 'package:gotomobile/api.dart';
import 'package:http/http.dart' as http;

class BranchesService {
  static Future<http.Response> getShopBranches(String token, int shopID) async {
    return http.get(API.shopBranches + "/" + shopID.toString(),
        headers: {"Authorization": token}).timeout(Duration(seconds: 2));
  }
}
