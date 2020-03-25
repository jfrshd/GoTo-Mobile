import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../api.dart';

class PostsService {
  static Future<http.Response> fetchPosts(String token,
      {@required int page, int shopID = -1}) async {
    String route =
        shopID == -1 ? API.postsAPI : API.shopPosts + "/" + shopID.toString();
    return http.get(route + "?page=" + page.toString(),
        headers: {"Authorization": token}).timeout(Duration(seconds: 2));
  }
}
