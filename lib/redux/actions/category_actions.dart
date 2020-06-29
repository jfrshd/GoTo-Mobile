import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gotomobile/models/category.dart';
import 'package:gotomobile/redux/states/app_state.dart';
import 'package:gotomobile/routes.dart';
import 'package:gotomobile/services/categories_service.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/utils/SharedPreferencesHelper.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'filter_actions.dart';

class SuccessCategoriesAction {
  final bool fromSharedPref;
  final List<Category> categoriesPayload;

  SuccessCategoriesAction(this.fromSharedPref, this.categoriesPayload);
}

class LoadingCategoriesAction {}

class FailLoadCategoriesAction {}

class ErrorLoadCategoriesAction {}
//////////////////////////////////////////////////////

class UpdatingCategoriesAction {}

class FailUpdateCategoriesAction {}

class ErrorUpdateCategoriesAction {}

ThunkAction<AppState> fetchCategoriesAction() {
  return (Store<AppState> store) async {
    store.dispatch(LoadingCategoriesAction());

    var _json =
        await SharedPreferencesHelper.getString(Constants.categoriesCode);
    if (_json.isNotEmpty) {
		var parsed = json.decode(_json);
		parsed = Map<String, dynamic>.from(
			json.decode("{\"categories\":" + parsed + "}"));
		final categories = parsed['categories']
			.map<Category>((json) => Category.fromJson(json))
			.toList();
		store.dispatch(SuccessCategoriesAction(true, categories));
		store.dispatch(AddCategoriesToFilterStateAction(categories));
    } else
      CategoriesService.fetchCategories(store.state.account.authToken)
          .then((response) {
        final parsed = Map<String, dynamic>.from(json.decode(response.body));
        if (parsed["status"] == "success") {
			final categories = parsed['categories']
				.map<Category>((json) => Category.fromJson(json))
				.toList();
			store.dispatch(SuccessCategoriesAction(false, categories));
			store.dispatch(AddCategoriesToFilterStateAction(categories));
        } else if (parsed["status"] == "fail") {
          store.dispatch(FailLoadCategoriesAction());
        } else if (parsed["status"] == "error") {}
      }).catchError((error) {
        print("getCategories error: ");
        print(error);
        store.dispatch(ErrorLoadCategoriesAction());
      });
  };
}

ThunkAction<AppState> saveCategoriesAction(
    List<Category> categories, BuildContext context) {
  return (Store<AppState> store) async {
    store.dispatch(UpdatingCategoriesAction());

    CategoriesService.updateSelectedCategories(
            store.state.account.authToken,
            store.state.account.accountID,
            categories
                .where((category) => category.selected)
                .map<int>((category) => category.id)
                .toList())
        .then((response) {
      final parsed = Map<String, dynamic>.from(json.decode(response.body));
      if (parsed["status"] == "success") {
        store.dispatch(SuccessCategoriesAction(false, categories));
        if (store.state.account.isFirstLaunch) {
          Navigator.pushNamed(context, Routes.regionsRoute);
        } else {
          Navigator.pop(context);
        }
      } else {
        store.dispatch(FailUpdateCategoriesAction());
      }
    }).catchError((e) {
      print("updateSelectedCategories error: ");
      print(e);
      store.dispatch(ErrorUpdateCategoriesAction());
    });
  };
}
