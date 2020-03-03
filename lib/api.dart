class API {
  static String serverAddress = "http://192.168.1.2:8000";

//  static String serverAddress = "http://10.0.2.2:8000"; // Android
//  static String serverAddress = "http://localhost:8000"; // iOS

  static String categoriesAPI = serverAddress + "/api/categories";
  static String regionsAPI = serverAddress + "/api/regions";
  static String postsAPI = serverAddress + "/api/posts";
  static String shopsAPI = serverAddress + "/api/shops";
  static String branchesAPI = serverAddress + "/api/branches";

  static String updateSelectedCategories =
      serverAddress + "/api/accounts/update-categories";
  static String updateSelectedRegions =
      serverAddress + "/api/accounts/update-regions";

  static String signIn = serverAddress + "/api/login";
  static String publishToken = serverAddress + "/api/accounts";
}
