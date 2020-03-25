import 'package:gotomobile/redux/actions/post_actions.dart';
import 'package:gotomobile/redux/states/post_state.dart';
import 'package:redux/redux.dart';

final postReducer = combineReducers<PostState>([
  TypedReducer<PostState, SuccessPostsAction>(_onLoaded),
  TypedReducer<PostState, LoadingPostsAction>(_onLoading),
  TypedReducer<PostState, FailLoadPostsAction>(_onFailLoad),
  TypedReducer<PostState, ErrorLoadPostsAction>(_onErrorLoad),
  TypedReducer<PostState, ToggleMorePostsToLoadAction>(_onToggleMoreToLoad),
  TypedReducer<PostState, ErrorLoadingMorePostsAction>(_onErrorLoadMore),
]);

PostState _onLoaded(PostState postState, SuccessPostsAction action) {
  return postState.copyWith(
    loading: false,
    failLoad: false,
    errorLoad: false,
    currentPage: postState.currentPage + 1,
    // TODO: bdna nshuf mawdo3 l filter krml ma yntz3 l sort on refresh aw pagination
    // TODO: fare2 l tertib iza request loadMore (add to the end) wala refresh (add to the top)
    posts: [...action.postsPayload, ...postState.posts],
  );
}

PostState _onLoading(PostState postState, LoadingPostsAction action) {
  return postState.copyWith(
    loading: true,
    failLoad: false,
    errorLoad: false,
    errorLoadingMore: false,
  );
}

PostState _onFailLoad(PostState postState, FailLoadPostsAction action) {
  return postState.copyWith(
    loading: false,
    failLoad: true,
    errorLoad: false,
  );
}

PostState _onErrorLoad(PostState postState, ErrorLoadPostsAction action) {
  return postState.copyWith(
    loading: false,
    failLoad: false,
    errorLoad: true,
  );
}

PostState _onToggleMoreToLoad(
    PostState postState, ToggleMorePostsToLoadAction action) {
  return postState.copyWith(moreToLoad: false);
}

PostState _onErrorLoadMore(
    PostState postState, ErrorLoadingMorePostsAction action) {
  return postState.copyWith(loading: false, errorLoadingMore: true);
}
