import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

import '../api.dart';

class PostsService {
  static Future<http.Response> fetchPosts(String token,
      {@required int page, int shopID = -1}) async {
    String route =
        shopID == -1 ? API.postsAPI : API.shopPosts + "/" + shopID.toString();
    return retry(
      // Make a GET request
      () => http.get(route + "?page=" + page.toString(),
          headers: {"Authorization": token}).timeout(Duration(seconds: 5)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
  }
}
