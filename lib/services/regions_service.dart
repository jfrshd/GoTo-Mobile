import 'dart:async';
import 'dart:io';

import 'package:gotomobile/api.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

class RegionsService {
  static Future<http.Response> fetchRegions(String token) async {
    return retry(
      // Make a GET request
      () => http.get(API.regionsAPI,
          headers: {"Authorization": token}).timeout(Duration(seconds: 5)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
  }

  static Future<http.Response> updateSelectedRegions(
      String token, int accountID, List<int> ids) async {
	  return retry(
		  // Make a GET request
			  () =>
			  http.post(API.updateSelectedRegions, headers: {
				  "Authorization": token
			  }, body: {
				  "account_id": accountID.toString(),
				  "region_ids[]": ids.toString(),
			  }).timeout(Duration(seconds: 5)),
		  // Retry on SocketException or TimeoutException
		  retryIf: (e) => e is SocketException || e is TimeoutException,
	  );
  }
}
