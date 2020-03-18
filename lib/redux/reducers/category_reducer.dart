import 'package:gotomobile/redux/actions/category_actions.dart';
import 'package:gotomobile/redux/states/states.dart';
import 'package:redux/redux.dart';

final categoryReducer = combineReducers<CategoryState>([
  TypedReducer<CategoryState, SuccessCategoriesAction>(_fetchCategoriesReducer),
  TypedReducer<CategoryState, LoadingCategoriesAction>(_onLoading),
  TypedReducer<CategoryState, FailCategoriesAction>(_onFail),
  TypedReducer<CategoryState, ErrorCategoriesAction>(_onError),
]);

CategoryState _fetchCategoriesReducer(
    CategoryState categoryState, SuccessCategoriesAction action) {
  return categoryState.copyWith(
    loading: false,
    fail: false,
    error: false,
    categories: action.categoriesPayload,
  );
}

CategoryState _onLoading(
    CategoryState categoryState, LoadingCategoriesAction action) {
  return categoryState.copyWith(
    loading: true,
    fail: false,
    error: false,
  );
}

CategoryState _onFail(
    CategoryState categoryState, FailCategoriesAction action) {
  return categoryState.copyWith(
    loading: false,
    fail: true,
    error: false,
  );
}

CategoryState _onError(
    CategoryState categoryState, ErrorCategoriesAction action) {
  return categoryState.copyWith(
    loading: false,
    fail: false,
    error: true,
  );
}
