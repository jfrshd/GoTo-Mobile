import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gotomobile/models/region.dart';
import 'package:gotomobile/redux/actions/account_actions.dart';
import 'package:gotomobile/redux/states/app_state.dart';
import 'package:gotomobile/routes.dart';
import 'package:gotomobile/services/regions_service.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/utils/SharedPreferencesHelper.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class SuccessRegionsAction {
  final bool fromSharedPref;
  final List<Region> regionsPayload;

  SuccessRegionsAction(this.fromSharedPref, this.regionsPayload);
}

class LoadingRegionsAction {}

class FailLoadRegionsAction {}

class ErrorLoadRegionsAction {}
//////////////////////////////////////////////////////

class UpdatingRegionsAction {}

class FailUpdateRegionsAction {}

class ErrorUpdateRegionsAction {}

ThunkAction<AppState> fetchRegionsAction() {
  return (Store<AppState> store) async {
    store.dispatch(LoadingRegionsAction());

    var _json = await SharedPreferencesHelper.getString(Constants.regionsCode);
    if (_json.isNotEmpty) {
      var parsed = json.decode(_json);
      parsed = Map<String, dynamic>.from(
          json.decode("{\"regions\":" + parsed + "}"));
      final regions = parsed['regions']
          .map<Region>((json) => Region.fromJson(json))
          .toList();
      store.dispatch(SuccessRegionsAction(true, regions));
    } else
      RegionsService.fetchRegions(store.state.account.authToken)
          .then((response) {
        final parsed = Map<String, dynamic>.from(json.decode(response.body));
        if (parsed["status"] == "success") {
          final regions = parsed['regions']
              .map<Region>((json) => Region.fromJson(json))
              .toList();
          store.dispatch(SuccessRegionsAction(false, regions));
        } else if (parsed["status"] == "fail") {
          store.dispatch(FailLoadRegionsAction());
        } else if (parsed["status"] == "error") {}
      }).catchError((error) {
        print("getRegions error: ");
        print(error);
        store.dispatch(ErrorLoadRegionsAction());
      });
  };
}

ThunkAction<AppState> saveRegionsAction(
    List<Region> regions, BuildContext context) {
  return (Store<AppState> store) async {
    store.dispatch(UpdatingRegionsAction());

    RegionsService.updateSelectedRegions(
            store.state.account.authToken,
            store.state.account.accountID,
            regions
                .where((region) => region.selected)
                .map<int>((region) => region.id)
                .toList())
        .then((response) {
      final parsed = Map<String, dynamic>.from(json.decode(response.body));
      if (parsed["status"] == "success") {
        store.dispatch(SuccessRegionsAction(false, regions));
        if (store.state.account.isFirstLaunch) {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.homePageRoute, (Route<dynamic> route) => false);
        } else {
          Navigator.pop(context);
        }
        if (store.state.account.isFirstLaunch)
          store.dispatch(ToggleFirstLaunchAction(false));
      } else {
        store.dispatch(FailUpdateRegionsAction());
      }
    }).catchError((e) {
      print("updateSelectedRegions error: ");
      print(e);
      store.dispatch(ErrorUpdateRegionsAction());
    });
  };
}
