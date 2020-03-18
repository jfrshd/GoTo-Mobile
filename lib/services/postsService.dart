import 'package:http/http.dart' as http;

Future<http.Response> getPosts({int shopID = -1, int page = 1}) async {
//  String token = await getAuthToken();
//  String route =
//      shopID == -1 ? API.postsAPI : API.shopPosts + "/" + shopID.toString();
//  return http.get(route + "?page=" + page.toString(),
//      headers: {"Authorization": token}).timeout(Duration(seconds: 2));
}

Future<http.Response> getShopPosts({int shopID}) async {
//  String token = await getAuthToken();
//
//  return http.get(API.shopPosts + "/" + shopID.toString(),
//      headers: {"Authorization": token}).timeout(Duration(seconds: 2));
}
