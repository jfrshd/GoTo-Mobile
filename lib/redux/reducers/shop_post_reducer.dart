import 'package:gotomobile/models/models.dart';
import 'package:gotomobile/redux/actions/shop_post_actions.dart';
import 'package:gotomobile/redux/states/shop_post_state.dart';
import 'package:redux/redux.dart';

final shopPostReducer = combineReducers<ShopPostState>([
  TypedReducer<ShopPostState, SuccessShopPostsAction>(_onLoaded),
  TypedReducer<ShopPostState, LoadingShopPostsAction>(_onLoading),
  TypedReducer<ShopPostState, FailLoadShopPostsAction>(_onFailLoad),
  TypedReducer<ShopPostState, ErrorLoadShopPostsAction>(_onErrorLoad),
  TypedReducer<ShopPostState, ToggleMoreShopPostsToLoadAction>(
      _onToggleMoreToLoad),
  TypedReducer<ShopPostState, ErrorLoadingMoreShopPostsAction>(
      _onErrorLoadMore),
]);

ShopPostState _onLoaded(
    ShopPostState postState, SuccessShopPostsAction action) {
  return postState.copyWith(
    loading: false,
    failLoad: false,
    errorLoad: false,
    currentPages: {
      ...postState.currentPages,
      action.shopID: action.currentPage
    },
    shopPosts: {
      ...postState.shopPosts,
      // TODO: recheck mawdo3 append order
      action.shopID: [
        ...action.postsPayload,
        ...(postState.shopPosts[action.shopID] ?? <Post>[]),
      ]
    },
  );
}

ShopPostState _onLoading(
    ShopPostState postState, LoadingShopPostsAction action) {
  return postState.copyWith(
    loading: true,
    failLoad: false,
    errorLoad: false,
    errorLoadingMore: false,
  );
}

ShopPostState _onFailLoad(
    ShopPostState postState, FailLoadShopPostsAction action) {
  return postState.copyWith(
    loading: false,
    failLoad: true,
    errorLoad: false,
  );
}

ShopPostState _onErrorLoad(
    ShopPostState postState, ErrorLoadShopPostsAction action) {
  return postState.copyWith(
    loading: false,
    failLoad: false,
    errorLoad: true,
  );
}

ShopPostState _onToggleMoreToLoad(
    ShopPostState postState, ToggleMoreShopPostsToLoadAction action) {
  return postState.copyWith(moreToLoad: false);
}

ShopPostState _onErrorLoadMore(
    ShopPostState postState, ErrorLoadingMoreShopPostsAction action) {
  return postState.copyWith(loading: false, errorLoadingMore: true);
}
