import 'dart:convert';

import 'package:gotomobile/models/category.dart';
import 'package:gotomobile/redux/states/app_state.dart';
import 'package:gotomobile/services/categories_service.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class SuccessCategoriesAction {
  final List<Category> categoriesPayload;

  SuccessCategoriesAction(this.categoriesPayload);
}

class LoadingCategoriesAction {}

class FailCategoriesAction {}

class ErrorCategoriesAction {}

ThunkAction<AppState> fetchCategoriesAction() {
  return (Store<AppState> store) async {
    store.dispatch(LoadingCategoriesAction());

    CategoriesService.fetchCategories(store.state.account.authToken)
        .then((response) {
      final parsed = Map<String, dynamic>.from(json.decode(response.body));
      if (parsed["status"] == "success") {
        final categories = parsed['categories']
            .map<Category>((json) => Category.fromJson(json))
            .toList();
        store.dispatch(SuccessCategoriesAction(categories));
      } else if (parsed["status"] == "fail") {
        store.dispatch(FailCategoriesAction());
      } else if (parsed["status"] == "error") {}
    }).catchError((error) {
      print("getCategories error: ");
      print(error);
      store.dispatch(ErrorCategoriesAction());
    });
  };
}
