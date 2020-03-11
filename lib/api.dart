class API {
  static String serverAddress = "http://goto-sale.com";

//  static String serverAddress = "http://192.168.1.15:8000";
//  static String serverAddress = "http://10.0.2.2:8000"; // Android
//  static String serverAddress = "http://localhost:8000"; // iOS

  static String login = serverAddress + "/api/login";
  static String publishToken = serverAddress + "/api/accounts";

  static String updateSelectedCategories =
      serverAddress + "/api/accounts/update-categories";
  static String updateSelectedRegions =
      serverAddress + "/api/accounts/update-regions";

  static String shopsAPI = serverAddress + "/api/shops";
  static String categoriesAPI = serverAddress + "/api/categories";
  static String regionsAPI = serverAddress + "/api/regions";
  static String postsAPI = serverAddress + "/api/posts";

  static String shopBranches = serverAddress + "/api/shop-branches";
  static String shopPosts = serverAddress + "/api/shop-posts";

  static String followShop = serverAddress + "/api/account-follow-shop";
  static String unFollowShop = serverAddress + "/api/account-unfollow-shop";
  static String shopFollowers = serverAddress + "/api/shop-followers";
  static String myFollowings = serverAddress + "/api/account-shops-followed";

  static String rateShop = serverAddress + "/api/account-rate-shop";
  static String shopRating = serverAddress + "/api/shop-rating";

  static String viewPost = serverAddress + "/api/account-view-post";
  static String postViews = serverAddress + "/api/post-views";
}
