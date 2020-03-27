import 'dart:async';
import 'dart:io';

import 'package:gotomobile/api.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

class CategoriesService {
  static Future<http.Response> fetchCategories(String token) async {
    return retry(
      // Make a GET request
      () => http.get(API.categoriesAPI,
          headers: {"Authorization": token}).timeout(Duration(seconds: 5)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
  }

  static Future<http.Response> updateSelectedCategories(
      String token, int accountID, List<int> ids) async {
	  return retry(
		  // Make a GET request
			  () =>
			  http.post(API.updateSelectedCategories, headers: {
				  "Authorization": token
			  }, body: {
				  "account_id": accountID.toString(),
				  "category_ids[]": ids.toString(),
			  }).timeout(Duration(seconds: 5)),
		  // Retry on SocketException or TimeoutException
		  retryIf: (e) => e is SocketException || e is TimeoutException,
	  );
  }
}
