import 'dart:async';
import 'dart:convert';

import 'package:gotomobile/models/shop.dart';
import 'package:gotomobile/redux/states/app_state.dart';
import 'package:gotomobile/services/shops_service.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class PerformSearchAction {
  final String searchTerm;

  PerformSearchAction(this.searchTerm);
}

class EmptySearchAction {}

class SuccessSearchAction {
  final List<Shop> shopsPayload;

  SuccessSearchAction(this.shopsPayload);
}

class SearchingAction {
  final String searchTerm;

  SearchingAction(this.searchTerm);
}

class FailSearchAction {}

class ErrorSearchAction {}

class CancelSearchAction {}

Stream<dynamic> searchEpic(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
      .whereType<PerformSearchAction>()
      // Using debounce will ensure we wait for the user to pause for
      // 150 milliseconds before making the API call
      .debounceTime(new Duration(milliseconds: 150))
      // Use SwitchMap. This will ensure if a new PerformSearchAction
      // is dispatched, the previous searchResults will be automatically
      // discarded.
      // This prevents your app from showing stale results.
      .switchMap((action) {
    return Stream.fromFuture(ShopsService.searchShops(
                store.state.account.authToken, action.searchTerm)
            .then((response) {
      final parsed = Map<String, dynamic>.from(json.decode(response.body));
      if (parsed["status"] == "success") {
        final shops =
            parsed['shops'].map<Shop>((json) => Shop.fromJson(json)).toList();
        return SuccessSearchAction(shops);
      }
      if (parsed["status"] == "fail") {
        return FailSearchAction();
      } else {
        return ErrorSearchAction();
      }
    }).catchError((error) {
      print("searchShops error: ");
      print(error);
      return ErrorSearchAction();
    }))
        // Use takeUntil. This will cancel the search in response to our
        // app dispatching a `CancelSearchAction`.
        .takeUntil(actions.whereType<CancelSearchAction>());
  });
}
