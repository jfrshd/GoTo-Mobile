import 'package:gotomobile/redux/actions/search_actions.dart';
import 'package:gotomobile/redux/states/search_state.dart';
import 'package:redux/redux.dart';

final searchReducer = combineReducers<SearchState>([
  TypedReducer<SearchState, SuccessSearchAction>(_onLoaded),
  TypedReducer<SearchState, SearchingAction>(_onLoading),
  TypedReducer<SearchState, FailSearchAction>(_onFailLoad),
  TypedReducer<SearchState, ErrorSearchAction>(_onErrorLoad),
]);

SearchState _onLoaded(SearchState searchState, SuccessSearchAction action) {
  return searchState.copyWith(
    loading: false,
    failLoad: false,
    errorLoad: false,
    shops: action.shopsPayload,
  );
}

SearchState _onLoading(SearchState searchState, SearchingAction action) {
  return searchState.copyWith(
    loading: true,
    failLoad: false,
    errorLoad: false,
    searchTerm: action.searchTerm,
  );
}

SearchState _onFailLoad(SearchState searchState, FailSearchAction action) {
  return searchState.copyWith(
    loading: false,
    failLoad: true,
    errorLoad: false,
  );
}

SearchState _onErrorLoad(SearchState searchState, ErrorSearchAction action) {
  return searchState.copyWith(
    loading: false,
    failLoad: false,
    errorLoad: true,
  );
}
