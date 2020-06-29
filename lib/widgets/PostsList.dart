import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gotomobile/models/shop.dart';
import 'package:gotomobile/pages/ErrorPage.dart';
import 'package:gotomobile/redux/actions/post_actions.dart';
import 'package:gotomobile/redux/actions/shop_actions.dart';
import 'package:gotomobile/redux/actions/shop_post_actions.dart';
import 'package:gotomobile/redux/states/app_state.dart';
import 'package:gotomobile/redux/states/post_state.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/widgets/post/PostItem.dart';
import 'package:redux/redux.dart';

import 'colorLoader/ColorLoader4.dart';

class PostsList extends StatelessWidget {
  final Shop shop;

  PostsList({this.shop});

  ScrollController _scrollController = new ScrollController();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  init(_ViewModel vm) {
    _scrollController.addListener(() => _scrollListener(vm));
    loadPosts(vm);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        onInitialBuild: (_ViewModel vm) => init(vm),
        onDispose: (store) => _scrollController.dispose(),
        converter: (store) {
          return _ViewModel.fromStore(store, shop);
        },
        builder: (BuildContext context, _ViewModel vm) {
          if (vm.postState.failLoad || vm.postState.errorLoad)
            return ErrorPage(
              vm.postState.failLoad
                  ? Constants.postsFail
                  : Constants.postsError,
              loadPosts,
              extraParams: vm,
            );

          return Container(
            child: vm.postState.posts.isEmpty && vm.postState.loading
                ? Center(
                    child: ColorLoader4(
                        color1: Colors.blue,
                        color2: Colors.blue[300],
                        color3: Colors.blue[100]),
                  )
                : RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: () {
                      return loadPosts(vm);
                    },
                    color: Theme.of(context).primaryColor,
                    child: ListView.builder(
                      controller: shop == null ? _scrollController : null,
                      itemCount: vm.postState.posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == vm.postState.posts.length) {
                          if (vm.postState.moreToLoad) {
                            if (vm.postState.loading)
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: ColorLoader4(
                                      color1: Colors.blue,
                                      color2: Colors.blue[300],
                                      color3: Colors.blue[100]),
                                ),
                              );
                            else if (vm.postState.errorLoadingMore)
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child:
                                        Text(Constants.postsPaginationError)),
                              );
                          }
                          return Container();
                        } else {
                          vm.postState.posts[index].shop ??= shop;
                          return PostItem(
                            index,
                            vm.postState.posts[index],
                            shop == null ? vm.selectShop : null,
                          );
                        }
                      },
                    ),
                  ),
          );
        });
  }

  loadPosts(vm) {
    return Future<void>(() => vm.fetchPosts(shop, _refreshIndicatorKey));
  }

  _scrollListener(_ViewModel vm) {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("reach the bottom");
      //TODO: Check if it's better to continuously load pages or wait for scroll.
      if (!vm.postState.loading) {
        if (vm.postState.moreToLoad) {
          loadPosts(vm);
        }
      }
    }

    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("reach the top");
    }
  }
}

class _ViewModel {
  final PostState postState;
  final Future<void> Function(Shop, GlobalKey<RefreshIndicatorState>)
  fetchPosts;
  final void Function(int, Shop, BuildContext) selectShop;

  _ViewModel({
    @required this.postState,
    @required this.fetchPosts,
    @required this.selectShop,
  });

  static _ViewModel fromStore(Store<AppState> store, Shop shop) {
    PostState postState;
    if (shop != null)
      postState = new PostState(
        loading: store.state.shopPostState.loading,
        failLoad: store.state.shopPostState.failLoad,
        errorLoad: store.state.shopPostState.errorLoad,
        moreToLoad: store.state.shopPostState.moreToLoad,
        errorLoadingMore: store.state.shopPostState.errorLoadingMore,
        currentPage: store.state.shopPostState.currentPages[shop.id] ?? 1,
        posts: store.state.shopPostState.shopPosts[shop.id] ?? [],
      );
    else
      postState = store.state.postState;

    return _ViewModel(
      postState: postState,
      fetchPosts:
          (Shop shop, GlobalKey<RefreshIndicatorState> _refreshIndicatorKey) {
        _refreshIndicatorKey.currentState?.show();
        shop == null
            ? store.dispatch(
            fetchPostsAction(store.state.shopPostState.moreToLoad))
            : store.dispatch(fetchShopPostsAction(shopID: shop.id));
        return new Future<void>(() {});
      },
      selectShop: (int index, Shop shop, BuildContext context) =>
          store.dispatch(
              selectShopAction(index: index, shop: shop, context: context)),
    );
  }
}
