import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gotomobile/models/models.dart';
import 'package:gotomobile/redux/actions/shop_actions.dart';
import 'package:gotomobile/redux/states/app_state.dart';
import 'package:redux/redux.dart';

import 'AboutTab.dart';
import 'BranchesTab.dart';
import 'PostsTab.dart';
import 'ShopDetailsHeader.dart';

// TODO: clean all imports

class ShopDetailsPage extends StatelessWidget {
  final String heroTag;

  ShopDetailsPage({@required this.heroTag});

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = new ScrollController();

  final List<Tab> tabList = [
    Tab(text: 'About'),
    Tab(text: 'Branches'),
    Tab(text: 'Posts'),
  ];

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      onInitialBuild: (_ViewModel vm) {
        _scrollController.addListener(_scrollListener);
      },
      onDispose: (Store<AppState> store) {
        _scrollController.dispose();
      },
      converter: (store) {
        return _ViewModel.fromStore(store);
      },
      builder: (BuildContext context, _ViewModel vm) {
//      if (vm.shopState.failLoad || vm.shopState.errorLoad)
//        return Scaffold(
//            key: _scaffoldKey,
//            backgroundColor: Colors.white,
//            appBar: createAppBar(),
//            body: ErrorPage(
//                vm.categoryState.failLoad
//                    ? Constants.categoriesFail
//                    : Constants.categoriesError,
//                vm.fetchCategories));

        return Scaffold(
          key: _scaffoldKey,
          body: Container(
              color: Theme.of(context).primaryColor,
              child: SafeArea(
                bottom: false,
                child: Container(
                    color: Colors.white,
                    child: NestedScrollView(
                      controller: _scrollController,
                      headerSliverBuilder:
                          (BuildContext context, bool boxIsScrolled) {
                        return <Widget>[
                          SliverList(
                            delegate: SliverChildListDelegate([
                              ShopDetailsHeader(vm.shop, heroTag, _scaffoldKey,
                                  vm.toggleFollow)
                            ]),
                          )
                        ];
                      },
                      body: DefaultTabController(
                        initialIndex: 2,
                        length: tabList.length,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: TabBar(
                                  indicatorColor:
                                      Theme.of(context).primaryColor,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  labelColor: Colors.black,
                                  tabs: tabList),
                            ),
                            Expanded(
                              child: TabBarView(
//                    physics: NeverScrollableScrollPhysics(),
                                children: tabList.map((Tab tab) {
                                  return _getPage(tab, vm.shop);
                                }).toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              )),
        );
      },
    );
  }

	Widget _getPage(Tab tab, Shop shop) {
		switch (tab.text) {
			case 'About':
				return AboutTab(shop.about);
			case 'Branches':
				return BranchesTab(shop.id);
			case 'Posts':
				return PostsTab(shop);
		}
		return AboutTab(shop.about);
	}

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("reach the bottom");
      // TODO: load data for the PostsTab :/
//      if (!_loadingPosts) {
//        if (_moreToLoad) {
//          loadPosts();
//        }
//      }
	}

	if (_scrollController.offset <=
		_scrollController.position.minScrollExtent &&
		!_scrollController.position.outOfRange) {
		print("reach the top");
	}
  }
}

class _ViewModel {
	final Shop shop;
	final Function(int) toggleFollow;

	_ViewModel({
		@required this.shop,
		@required this.toggleFollow,
	});

	static _ViewModel fromStore(Store<AppState> store) {
		return _ViewModel(
			shop: store.state.shopState.shops[store.state.shopState
				.selectedShopId],
			toggleFollow: (shopID) =>
				store.dispatch(toggleFollowShopAction(shopID: shopID)),
		);
	}
}
