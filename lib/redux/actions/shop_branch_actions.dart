import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gotomobile/models/models.dart';
import 'package:gotomobile/redux/states/app_state.dart';
import 'package:gotomobile/services/branchesService.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class SuccessShopBranchesAction {
  final int shopID;
  final List<Branch> branchesPayload;

  SuccessShopBranchesAction(this.shopID, this.branchesPayload);
}

class LoadingShopBranchesAction {}

class FailLoadShopBranchesAction {}

class ErrorLoadShopBranchesAction {}

class ToggleMoreShopBranchesToLoadAction {}

class ErrorLoadingMoreShopBranchesAction {}

ThunkAction<AppState> fetchShopBranchesAction({@required int shopID}) {
  return (Store<AppState> store) async {
    if (!store.state.shopBranchState.shopBranches.containsKey(shopID)) {
      store.dispatch(LoadingShopBranchesAction());
      BranchesService.getShopBranches(store.state.account.authToken, shopID)
          .then((response) {
        final parsed = Map<String, dynamic>.from(json.decode(response.body));
        if (parsed["status"] == "success") {
          final branches = parsed['branches']
              .map<Branch>((json) => Branch.fromJson(json))
              .toList();
          store.dispatch(SuccessShopBranchesAction(shopID, branches));
        } else if (parsed["status"] == "fail") {
          store.dispatch(FailLoadShopBranchesAction());
        }
      }).catchError((e) {
        print("getShopBranches error: ");
        print(e);
        store.dispatch(ErrorLoadShopBranchesAction());
      });
    }
  };
}
