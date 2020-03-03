import 'dart:async';

import 'package:http/http.dart' as http;

import '../api.dart';
import 'authService.dart';

Future<http.Response> getShop(int shopID) async {
  String token = await getAuthToken();

  return http.get(API.shopsAPI + "/" + shopID.toString(),
      headers: {"Authorization": token}).timeout(Duration(seconds: 2));
}
