import 'package:gotomobile/redux/actions/shop_actions.dart';
import 'package:gotomobile/redux/states/shop_state.dart';
import 'package:redux/redux.dart';

final shopReducer = combineReducers<ShopState>([
  TypedReducer<ShopState, SelectShopAction>(_onSelect),
  TypedReducer<ShopState, SuccessShopAction>(_onLoaded),
  TypedReducer<ShopState, LoadingShopAction>(_onLoading),
  TypedReducer<ShopState, FailLoadShopAction>(_onFailLoad),
  TypedReducer<ShopState, ErrorLoadShopAction>(_onErrorLoad),
  TypedReducer<ShopState, SuccessToggleFollowShopAction>(
      _onSuccessToggleFollow),
  TypedReducer<ShopState, TogglingFollowShopAction>(_onTogglingFollow),
  TypedReducer<ShopState, FailToggleFollowShopAction>(_onFailToggleFollow),
  TypedReducer<ShopState, ErrorToggleFollowShopAction>(_onErrorToggleFollow),
]);

ShopState _onSelect(ShopState shopState, SelectShopAction action) {
  return shopState.copyWith(
    selectedShopId: action.shop.id,
    shops: {...shopState.shops, action.shop.id: action.shop},
  );
}

ShopState _onLoaded(ShopState shopState, SuccessShopAction action) {
  return shopState.copyWith(
    loading: false,
    failLoad: false,
    errorLoad: false,
    shops: {...shopState.shops, action.shopPayload.id: action.shopPayload},
  );
}

ShopState _onLoading(ShopState shopState, LoadingShopAction action) {
  return shopState.copyWith(
    loading: true,
    failLoad: false,
    errorLoad: false,
  );
}

ShopState _onFailLoad(ShopState shopState, FailLoadShopAction action) {
  return shopState.copyWith(
    loading: false,
    failLoad: true,
    errorLoad: false,
  );
}

ShopState _onErrorLoad(ShopState shopState, ErrorLoadShopAction action) {
  return shopState.copyWith(
    loading: false,
    failLoad: false,
    errorLoad: true,
  );
}

ShopState _onSuccessToggleFollow(
    ShopState shopState, SuccessToggleFollowShopAction action) {
  return shopState
      .copyWith(shops: {...shopState.shops, action.shop.id: action.shop});
}

ShopState _onTogglingFollow(
    ShopState shopState, TogglingFollowShopAction action) {
  return shopState.copyWith(
    togglingFollow: true,
    failToggleFollow: false,
    errorToggleFollow: false,
  );
}

ShopState _onFailToggleFollow(
    ShopState shopState, FailToggleFollowShopAction action) {
  return shopState.copyWith(
    togglingFollow: false,
    failToggleFollow: true,
    errorToggleFollow: false,
  );
}

ShopState _onErrorToggleFollow(
    ShopState shopState, ErrorToggleFollowShopAction action) {
  return shopState.copyWith(
    togglingFollow: false,
    failToggleFollow: false,
    errorToggleFollow: true,
  );
}
