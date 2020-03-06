import 'package:gotomobile/api.dart';
import 'package:gotomobile/services/authService.dart';
import 'package:http/http.dart' as http;

Future<http.Response> getPosts({int page = 1}) async {
  String token = await getAuthToken();

  return http.get(API.postsAPI + "?page=" + page.toString(),
      headers: {"Authorization": token}).timeout(Duration(seconds: 2));
}

Future<http.Response> getShopPosts({int shopID}) async {
  String token = await getAuthToken();

  return http.get(API.brancssshesAPI + "/" + shopID.toString(),
      headers: {"Authorization": token}).timeout(Duration(seconds: 2));
//	try {
//		http.Response response = await
//	} on Exception catch (e) {
//		print("TIMED OUT POSTS Page: " + page.toString());
//		_httpClient.close();
//		if (page == 1) {
//			setState(() {
//				_timedout = true;
//				_loadingItems = false;
//			});
//		} else {
//			_getItems(page: page);
//		}
//		return;
//	}
//	_httpClient.close();
//
//	var jsonresponseinfo;
//	try {
//		jsonresponseinfo = json.decode(response.body);
//	} on Exception catch (e) {
//		print("ERROR PARSING JSON");
//		_getItems(page: page);
//		return;
//	}
//
//	Map<String, dynamic> jsonresponse =
//	(json.decode(response.body))['data'] as Map<String, dynamic>;
//	List<dynamic> posts = jsonresponse.values.toList();
//	for (int i = 0; i < posts.length; i++) {
//		if (posts[i]["images"][0] != null) {
//			if (posts[i]["images"].length == 1) {
//				_items.add(
//					new Add(
//						company: posts[i]["company_name"],
//						saleImage: posts[i]["images"][0],
//						category: posts[i]["category_name"],
//						companyLogo: posts[i]["company_logo"]),
//				);
//			} else if (posts[i]["images"].length >= 1) {
//				_items.add(
//					new Flyer(
//						company: posts[i]["company_name"],
//						images: List<String>.from(posts[i]["images"]),
//						category: posts[i]["category_name"],
//						companyLogo: posts[i]["company_logo"]),
//				);
//			}
//		}
//	}
//	_items_current = []..addAll(_items);
//	_loadingItems = false;
//	setState(() {
//		if (page == 1) {
//			_timedout = false;
//		}
//	});
//
//	if (jsonresponseinfo["next_page_url"] != null) {
//		_currentpage = _currentpage + 1;
//		print("More To Load");
////    TODO: Check if it's better to continuously load pages or wait for scroll.
////    Future.delayed(Duration(seconds: 2), () {
////        getItems(page: page + 1);
////      });
//		_moreToLoad = true;
//	} else {
//		_moreToLoad = false;
//	}
}
