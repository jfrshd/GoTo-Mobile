import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gotomobile/models/models.dart';
import 'package:gotomobile/pages/ErrorPage.dart';
import 'package:gotomobile/redux/actions/shop_actions.dart';
import 'package:gotomobile/redux/states/app_state.dart';
import 'package:gotomobile/redux/states/search_state.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:redux/redux.dart';

import 'ShopItem.dart';
import 'colorLoader/ColorLoader4.dart';

class ShopsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(converter: (store) {
      return _ViewModel.fromStore(store);
    }, builder: (BuildContext context, _ViewModel vm) {
      if (vm.searchState.failLoad || vm.searchState.errorLoad)
        return ErrorPage(
            vm.searchState.failLoad
                ? Constants.shopsSearchFail
                : Constants.shopsSearchError,
            () {});

      if (!vm.searchState.loading && vm.searchState.searchTerm == '') {
        return Center(child: Text('Start typing to search our shops'));
      }

      if (vm.searchState.shops.isNotEmpty && vm.searchState.searchTerm != '') {
        if (vm.searchState.loading) {
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Center(
                  child: Text('Searching...'),
                ),
              ),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: vm.searchState.shops.length,
                  itemBuilder: (context, index) {
                    return ShopItem(
                        index, vm.searchState.shops[index], vm.selectShop);
                  },
                ),
              ),
            ],
          );
        } else {
          return ListView.builder(
            itemCount: vm.searchState.shops.length,
            itemBuilder: (context, index) {
              return ShopItem(
                  index, vm.searchState.shops[index], vm.selectShop);
            },
          );
        }
      }
      if (vm.searchState.searchTerm != '' && vm.searchState.shops.isEmpty) {
        if (vm.searchState.loading) {
          return Center(
            child: ColorLoader4(
                color1: Colors.blue,
                color2: Colors.blue[300],
                color3: Colors.blue[100]),
          );
        } else {
          return Center(child: Text('No results found'));
        }
      }
      // TODO: remove
      return Container();
    });
  }
}

class _ViewModel {
  final SearchState searchState;
  final void Function(int, Shop, BuildContext) selectShop;

  _ViewModel({
    @required this.searchState,
    @required this.selectShop,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      searchState: store.state.searchState,
      selectShop: (int index, Shop shop, BuildContext context) =>
          store.dispatch(
              selectShopAction(index: index, shop: shop, context: context)),
    );
  }
}
