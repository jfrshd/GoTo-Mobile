import 'dart:convert';

import 'package:gotomobile/redux/actions/region_actions.dart';
import 'package:gotomobile/redux/states/region_state.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/utils/SharedPreferencesHelper.dart';
import 'package:redux/redux.dart';

final regionReducer = combineReducers<RegionState>([
  TypedReducer<RegionState, SuccessRegionsAction>(_onLoaded),
  TypedReducer<RegionState, LoadingRegionsAction>(_onLoading),
  TypedReducer<RegionState, FailLoadRegionsAction>(_onFailLoad),
  TypedReducer<RegionState, ErrorLoadRegionsAction>(_onErrorLoad),
  TypedReducer<RegionState, UpdatingRegionsAction>(_onUpdating),
  TypedReducer<RegionState, FailUpdateRegionsAction>(_onFailUpdate),
  TypedReducer<RegionState, ErrorUpdateRegionsAction>(_onErrorUpdate),
]);

RegionState _onLoaded(RegionState regionState, SuccessRegionsAction action) {
  if (!action.fromSharedPref) {
    SharedPreferencesHelper.setString(
      Constants.regionsCode,
      json.encode(action.regionsPayload.toString()),
    );
  }
  return regionState.copyWith(
    loading: false,
    failLoad: false,
    errorLoad: false,
    updating: false,
    failUpdate: false,
    errorUpdate: false,
    regions: action.regionsPayload,
  );
}

RegionState _onLoading(RegionState regionState, LoadingRegionsAction action) {
  return regionState.copyWith(
    loading: true,
    failLoad: false,
    errorLoad: false,
  );
}

RegionState _onFailLoad(RegionState regionState, FailLoadRegionsAction action) {
  return regionState.copyWith(
    loading: false,
    failLoad: true,
    errorLoad: false,
  );
}

RegionState _onErrorLoad(
    RegionState regionState, ErrorLoadRegionsAction action) {
  return regionState.copyWith(
    loading: false,
    failLoad: false,
    errorLoad: true,
  );
}

RegionState _onUpdating(RegionState regionState, UpdatingRegionsAction action) {
  return regionState.copyWith(
    updating: true,
    failUpdate: false,
    errorUpdate: false,
  );
}

RegionState _onFailUpdate(
    RegionState regionState, FailUpdateRegionsAction action) {
  return regionState.copyWith(
    updating: false,
    failUpdate: true,
    errorUpdate: false,
  );
}

RegionState _onErrorUpdate(
    RegionState regionState, ErrorUpdateRegionsAction action) {
  return regionState.copyWith(
    updating: false,
    failUpdate: false,
    errorUpdate: true,
  );
}
