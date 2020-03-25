import 'dart:convert';

import 'package:gotomobile/models/post.dart';
import 'package:gotomobile/redux/states/app_state.dart';
import 'package:gotomobile/services/posts_service.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class SuccessPostsAction {
  final List<Post> postsPayload;

  SuccessPostsAction(this.postsPayload);
}

class LoadingPostsAction {}

class FailLoadPostsAction {}

class ErrorLoadPostsAction {}

class ToggleMorePostsToLoadAction {}

class ErrorLoadingMorePostsAction {}

ThunkAction<AppState> fetchPostsAction() {
  return (Store<AppState> store) async {
    store.dispatch(LoadingPostsAction());
    final currentPage = store.state.postState.currentPage;
    PostsService.fetchPosts(store.state.account.authToken, page: currentPage)
        .then((response) {
      final parsed = Map<String, dynamic>.from(json.decode(response.body));
      if (parsed["status"] == "success") {
        final posts = parsed['posts']['data']
            .map<Post>((json) => Post.fromJson(json))
            .toList();
        store.dispatch(SuccessPostsAction(posts));
        if (currentPage + 1 > parsed['posts']["last_page"])
          store.dispatch(ToggleMorePostsToLoadAction());
      } else if (parsed["status"] == "fail") {
        store.dispatch(FailLoadPostsAction());
      }
    }).catchError((error) {
      print("getPosts error: ");
      print(error);
      if (currentPage == 1)
        store.dispatch(ErrorLoadPostsAction());
      else
        store.dispatch(ErrorLoadingMorePostsAction());
    });
  };
}
