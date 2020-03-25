import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gotomobile/models/shop.dart';
import 'package:gotomobile/pages/ShopDetailsPage/ShopDetailsPage.dart';
import 'package:gotomobile/redux/actions/shop_branch_actions.dart';
import 'package:gotomobile/redux/states/app_state.dart';
import 'package:gotomobile/services/shops_service.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class SelectShopAction {
  final Shop shop;

  SelectShopAction(this.shop);
}

class SuccessShopAction {
  final Shop shopPayload;

  SuccessShopAction(this.shopPayload);
}

class LoadingShopAction {}

class FailLoadShopAction {}

class ErrorLoadShopAction {}

class SuccessToggleFollowShopAction {
  final Shop shop;

  SuccessToggleFollowShopAction(this.shop);
}

class TogglingFollowShopAction {}

class FailToggleFollowShopAction {}

class ErrorToggleFollowShopAction {}

ThunkAction<AppState> selectShopAction({
  @required int index,
  @required Shop shop,
  @required BuildContext context,
}) {
  return (Store<AppState> store) async {
    store.dispatch(fetchShopBranchesAction(shopID: shop.id));
    if (store.state.shopState.shops.containsKey(shop.id)) {
      store.dispatch(SelectShopAction(store.state.shopState.shops[shop.id]));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              ShopDetailsPage(heroTag: index.toString()),
        ),
      );
    } else {
      store.dispatch(SelectShopAction(shop));
      store.dispatch(LoadingShopAction());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              ShopDetailsPage(heroTag: index.toString()),
        ),
      );
      ShopsService.getShop(
        store.state.account.authToken,
        store.state.account.accountID,
        shop.id,
      ).then((response) {
        final parsed = Map<String, dynamic>.from(json.decode(response.body));
        if (parsed["status"] == "success") {
          final shop = Shop.fromJson(parsed['shop']);
          store.dispatch(SuccessShopAction(shop));
        } else if (parsed["status"] == "fail") {
          store.dispatch(FailLoadShopAction());
        } else if (parsed["status"] == "error") {
          store.dispatch(ErrorLoadShopAction());
        }
      }).catchError((e) {
        print("getShop error: ");
        print(e);
        store.dispatch(ErrorLoadShopAction());
      });
    }
  };
}

ThunkAction<AppState> toggleFollowShopAction({
  @required int shopID,
}) {
  return (Store<AppState> store) async {
    store.dispatch(TogglingFollowShopAction());
    final shop = store.state.shopState.shops[shopID];
    ShopsService.toggleFollowShop(
      store.state.account.authToken,
      store.state.account.accountID,
      shopID,
      shop.followed,
    ).then((response) {
      final parsed = Map<String, dynamic>.from(json.decode(response.body));
      if (parsed["status"] == "success") {
        shop.followed = !shop.followed;
        store.dispatch(SuccessToggleFollowShopAction(shop));
      } else if (parsed["status"] == "fail") {
        store.dispatch(FailToggleFollowShopAction());
      }
    }).catchError((error) {
      print("toggleFollowShop error: ");
      print(error);
      store.dispatch(ErrorToggleFollowShopAction());
    });
  };
}
