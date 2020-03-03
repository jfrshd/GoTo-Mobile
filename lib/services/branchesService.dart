import 'dart:async';

import 'package:http/http.dart' as http;

import '../api.dart';
import 'authService.dart';

Future<http.Response> getShopBranches(int shopID) async {
  String token = await getAuthToken();

  return http.get(API.branchesAPI + "/" + shopID.toString(),
      headers: {"Authorization": token}).timeout(Duration(seconds: 2));
}
