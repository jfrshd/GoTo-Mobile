import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gotomobile/pages/FiltersPage.dart';
import 'package:gotomobile/redux/actions/home_appbar_actions.dart';
import 'package:gotomobile/redux/actions/search_actions.dart';
import 'package:gotomobile/redux/states/app_state.dart';
import 'package:gotomobile/redux/states/home_appbar_state.dart';
import 'package:gotomobile/widgets/HomeAppBar.dart';
import 'package:gotomobile/widgets/PostsList.dart';
import 'package:gotomobile/widgets/ShopsList.dart';
import 'package:gotomobile/widgets/drawer/CustomDrawer.dart';
import 'package:redux/redux.dart';

class HomePage extends StatelessWidget {
  HomeAppBar homeAppBar = HomeAppBar();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(converter: (store) {
      return _ViewModel.fromStore(store);
    }, builder: (BuildContext context, _ViewModel vm) {
      return WillPopScope(
        onWillPop: () => _onWillPop(homeAppBar, vm),
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          drawer: CustomDrawer(),
          appBar: homeAppBar,
          body: vm.homeState.isSearch
              ? new ShopsList()
              : vm.homeState.isFilter ? new FiltersPage() : new PostsList(),
        ),
      );
    });
  }

  Future<bool> _onWillPop(HomeAppBar homeAppBar, _ViewModel vm) async {
    if (vm.homeState.isSearch) {
      homeAppBar.toggleSearch(
        vm.emptySearch,
        vm.toggleSearch,
        vm.toggleForceFocus,
      );
      return false;
    } else {
      return true;
    }
  }
}

class _ViewModel {
  final HomeState homeState;
  final void Function(String) search;
  final void Function() emptySearch;
  final void Function(bool) toggleSearch;
  final void Function(bool) toggleForceFocus;

  _ViewModel({
    @required this.homeState,
    @required this.search,
    @required this.emptySearch,
    @required this.toggleSearch,
    @required this.toggleForceFocus,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      homeState: store.state.homeState,
      search: (searchTerm) {
        store.dispatch(CancelSearchAction());
        store.dispatch(SearchingAction(searchTerm));
        store.dispatch(PerformSearchAction(searchTerm));
      },
      emptySearch: () => store.dispatch(EmptySearchAction()),
      toggleSearch: (isSearch) => store.dispatch(ToggleSearchAction(isSearch)),
      toggleForceFocus: (isForceFocus) =>
          store.dispatch(ToggleForceFocusAction(isForceFocus)),
    );
  }
}
