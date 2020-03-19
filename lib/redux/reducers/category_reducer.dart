import 'dart:convert';

import 'package:gotomobile/redux/actions/category_actions.dart';
import 'package:gotomobile/redux/states/states.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/utils/SharedPreferencesHelper.dart';
import 'package:redux/redux.dart';

final categoryReducer = combineReducers<CategoryState>([
  TypedReducer<CategoryState, SuccessCategoriesAction>(_onLoaded),
  TypedReducer<CategoryState, LoadingCategoriesAction>(_onLoading),
  TypedReducer<CategoryState, FailLoadCategoriesAction>(_onFailLoad),
  TypedReducer<CategoryState, ErrorLoadCategoriesAction>(_onErrorLoad),
  TypedReducer<CategoryState, UpdatingCategoriesAction>(_onUpdating),
  TypedReducer<CategoryState, FailUpdateCategoriesAction>(_onFailUpdate),
  TypedReducer<CategoryState, ErrorUpdateCategoriesAction>(_onErrorUpdate),
]);

CategoryState _onLoaded(CategoryState categoryState,
	SuccessCategoriesAction action) {
	if (!action.fromSharedPref) {
		SharedPreferencesHelper.setString(
			Constants.categoriesCode,
			json.encode(action.categoriesPayload.toString()),
		);
	}
	return categoryState.copyWith(
		loading: false,
		failLoad: false,
		errorLoad: false,
		updating: false,
		failUpdate: false,
		errorUpdate: false,
		categories: action.categoriesPayload,
	);
}

CategoryState _onLoading(CategoryState categoryState, LoadingCategoriesAction action) {
	return categoryState.copyWith(
		loading: true,
		failLoad: false,
		errorLoad: false,
	);
}

CategoryState _onFailLoad(CategoryState categoryState,
	FailLoadCategoriesAction action) {
	return categoryState.copyWith(
		loading: false,
		failLoad: true,
		errorLoad: false,
	);
}

CategoryState _onErrorLoad(CategoryState categoryState,
	ErrorLoadCategoriesAction action) {
	return categoryState.copyWith(
		loading: false,
		failLoad: false,
		errorLoad: true,
	);
}

CategoryState _onUpdating(CategoryState categoryState,
	UpdatingCategoriesAction action) {
	return categoryState.copyWith(
		updating: true,
		failUpdate: false,
		errorUpdate: false,
	);
}

CategoryState _onFailUpdate(CategoryState categoryState,
	FailUpdateCategoriesAction action) {
	return categoryState.copyWith(
		updating: false,
		failUpdate: true,
		errorUpdate: false,
	);
}

CategoryState _onErrorUpdate(CategoryState categoryState,
	ErrorUpdateCategoriesAction action) {
	return categoryState.copyWith(
		updating: false,
		failUpdate: false,
		errorUpdate: true,
	);
}
