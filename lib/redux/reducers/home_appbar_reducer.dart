import 'package:gotomobile/redux/actions/home_appbar_actions.dart';
import 'package:gotomobile/redux/states/home_appbar_state.dart';
import 'package:redux/redux.dart';

final homeAppBarReducer = combineReducers<HomeState>([
  TypedReducer<HomeState, ToggleFilterAction>(_toggleFilter),
  TypedReducer<HomeState, ToggleSearchAction>(_toggleSearch),
  TypedReducer<HomeState, ToggleForceFocusAction>(_toggleForceFocus),
  TypedReducer<HomeState, EndDelayAction>(_endDelay),
]);

HomeState _toggleFilter(HomeState homeState, ToggleFilterAction action) {
  return homeState.copyWith(isFilter: !homeState.isFilter);
}

HomeState _toggleSearch(HomeState homeState, ToggleSearchAction action) {
  return homeState.copyWith(isSearch: action.isSearch);
}

HomeState _toggleForceFocus(
    HomeState homeState, ToggleForceFocusAction action) {
  return homeState.copyWith(forceFocus: action.isForceFocus);
}

HomeState _endDelay(HomeState homeState, EndDelayAction action) {
  return homeState.copyWith(delayEnded: true);
}
