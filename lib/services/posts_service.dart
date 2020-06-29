import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gotomobile/redux/states/filter_state.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

import '../api.dart';

class PostsService {
    static Future<http.Response> fetchPosts(String token,
      {@required int page,
      int shopID = -1,
      int accountId = -1,
      bool favorites = true,
      FilterState filterState}) async {
    String route =
        shopID == -1 ? API.postsAPI : API.shopPosts + "/" + shopID.toString();
    String url;
    if (filterState == null) {
      url = route + "?page=" + page.toString();
    } else {
      final categoriesIds = filterState.categories
          .where((category) => category.selected)
          .map<int>((category) => category.id)
          .toList();
      final postTypes = filterState.postTypes
          .where((postType) => postType.selected)
          .map<int>((postType) => postType.id)
          .toList();
      url = route +
          "?page=" +
          page.toString() +
          "&post_types=" +
          postTypes
              .toString()
              .substring(1, postTypes.toString().length - 1)
              .replaceAll(' ', '') +
          "&category_ids=" +
          categoriesIds
              .toString()
              .substring(1, postTypes.toString().length - 1)
              .replaceAll(' ', '') +
          "&account_id=" +
          accountId.toString() +
          "&others=" +
          (!favorites ? "1" : "0");
    }
    print(url);
    return retry(
      // Make a GET request
      () => http.get(url,
          headers: {"Authorization": token}).timeout(Duration(seconds: 5)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
  }
}
