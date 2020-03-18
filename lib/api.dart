class API {
  static const String serverAddress = "http://goto-sale.com";

//  static const String serverAddress = "http://192.168.0.102:8000";

//  static const String serverAddress = "http://10.0.2.2:8000"; // Android
//  static const String serverAddress = "http://localhost:8000"; // iOS

  static const String login = serverAddress + "/api/login";
  static const String publishToken = serverAddress + "/api/accounts";

  static const String updateSelectedCategories =
      serverAddress + "/api/accounts/update-categories";
  static const String updateSelectedRegions =
      serverAddress + "/api/accounts/update-regions";

  static const String shopsAPI = serverAddress + "/api/shops";
  static const String categoriesAPI = serverAddress + "/api/categories";
  static const String regionsAPI = serverAddress + "/api/regions";
  static const String postsAPI = serverAddress + "/api/posts";

  static const String shopBranches = serverAddress + "/api/shop-branches";
  static const String shopPosts = serverAddress + "/api/shop-posts";

  static const String followShop = serverAddress + "/api/account-follow-shop";
  static const String unFollowShop =
      serverAddress + "/api/account-unfollow-shop";
  static const String shopFollowers = serverAddress + "/api/shop-followers";
  static const String myFollowings =
      serverAddress + "/api/account-shops-followed";

  static const String rateShop = serverAddress + "/api/account-rate-shop";
  static const String shopRating = serverAddress + "/api/shop-rating";

  static const String viewPost = serverAddress + "/api/account-view-post";
  static const String postViews = serverAddress + "/api/post-views";

  static const String searchShops = serverAddress + "/api/search-shops";
}
