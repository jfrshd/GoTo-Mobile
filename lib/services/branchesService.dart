import 'dart:async';
import 'dart:io';

import 'package:gotomobile/api.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

class BranchesService {
  static Future<http.Response> getShopBranches(String token, int shopID) async {
    return retry(
      // Make a GET request
      () => http.get(API.shopBranches + "/" + shopID.toString(),
          headers: {"Authorization": token}).timeout(Duration(seconds: 5)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
  }
}
