import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gotomobile/models/post.dart';
import 'package:gotomobile/redux/states/app_state.dart';
import 'package:gotomobile/services/posts_service.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class SuccessShopPostsAction {
  final int shopID, currentPage;
  final List<Post> postsPayload;

  SuccessShopPostsAction(this.shopID, this.currentPage, this.postsPayload);
}

class LoadingShopPostsAction {}

class FailLoadShopPostsAction {}

class ErrorLoadShopPostsAction {}

class ToggleMoreShopPostsToLoadAction {}

class ErrorLoadingMoreShopPostsAction {}

// TODO: fetch request number of retries before surrender
ThunkAction<AppState> fetchShopPostsAction({@required int shopID}) {
  return (Store<AppState> store) async {
    store.dispatch(LoadingShopPostsAction());
    final currentPage =
        store.state.shopPostState.currentPages.containsKey(shopID)
            ? store.state.shopPostState.currentPages[shopID]
            : 1;
    PostsService.fetchPosts(store.state.account.authToken,
            page: currentPage, shopID: shopID)
        .then((response) {
      final parsed = Map<String, dynamic>.from(json.decode(response.body));
      if (parsed["status"] == "success") {
        final posts = parsed['posts']['data']
            .map<Post>((json) => Post.fromJson(json))
            .toList();
        store.dispatch(SuccessShopPostsAction(shopID, currentPage + 1, posts));
        if (currentPage + 1 > parsed['posts']["last_page"])
          store.dispatch(ToggleMoreShopPostsToLoadAction());
      } else if (parsed["status"] == "fail") {
        store.dispatch(FailLoadShopPostsAction());
      }
    }).catchError((error) {
      print("getShopPosts error: ");
      print(error);
      if (currentPage == 1)
        store.dispatch(ErrorLoadShopPostsAction());
      else
        store.dispatch(ErrorLoadingMoreShopPostsAction());
    });
  };
}
