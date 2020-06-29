import 'package:gotomobile/redux/actions/filter_actions.dart';
import 'package:gotomobile/redux/states/filter_state.dart';
import 'package:redux/redux.dart';

final filterReducer = combineReducers<FilterState>([
  TypedReducer<FilterState, AddCategoriesToFilterStateAction>(_onLoaded),
  TypedReducer<FilterState, SaveFilterPostTypesAction>(_saveFilterPostTypes),
  TypedReducer<FilterState, SaveFilterSortTypeAction>(_saveFilterSortTypes),
  TypedReducer<FilterState, SaveFilterCategoriesAction>(_saveFilterCategories),
]);

FilterState _onLoaded(
    FilterState filterState, AddCategoriesToFilterStateAction action) {
  return filterState.copyWith(categories: action.categoriesPayload);
}

FilterState _saveFilterPostTypes(
    FilterState filterState, SaveFilterPostTypesAction action) {
  action.postTypesPayload[action.index].selected =
      !action.postTypesPayload[action.index].selected;

  return filterState.copyWith(postTypes: action.postTypesPayload);
}

FilterState _saveFilterSortTypes(
    FilterState filterState, SaveFilterSortTypeAction action) {
  action.sortTypesPayload.forEach((e) => e.selected = false);
  action.sortTypesPayload[action.index].selected =
      !action.sortTypesPayload[action.index].selected;
  return filterState.copyWith(sortTypes: action.sortTypesPayload);
}

FilterState _saveFilterCategories(
    FilterState filterState, SaveFilterCategoriesAction action) {
  action.categoriesPayload[action.index].selected =
      !action.categoriesPayload[action.index].selected;
  return filterState.copyWith(categories: action.categoriesPayload);
}
