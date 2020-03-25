import 'package:gotomobile/redux/actions/shop_branch_actions.dart';
import 'package:gotomobile/redux/states/shop_branch_state.dart';
import 'package:redux/redux.dart';

final shopBranchReducer = combineReducers<ShopBranchState>([
  TypedReducer<ShopBranchState, SuccessShopBranchesAction>(_onLoaded),
  TypedReducer<ShopBranchState, LoadingShopBranchesAction>(_onLoading),
  TypedReducer<ShopBranchState, FailLoadShopBranchesAction>(_onFailLoad),
  TypedReducer<ShopBranchState, ErrorLoadShopBranchesAction>(_onErrorLoad),
]);

ShopBranchState _onLoaded(
    ShopBranchState branchState, SuccessShopBranchesAction action) {
  return branchState.copyWith(
    loading: false,
    failLoad: false,
    errorLoad: false,
    shopBranches: {
      ...branchState.shopBranches,
      action.shopID: action.branchesPayload
    },
  );
}

ShopBranchState _onLoading(
    ShopBranchState branchState, LoadingShopBranchesAction action) {
  return branchState.copyWith(
    loading: true,
    failLoad: false,
    errorLoad: false,
  );
}

ShopBranchState _onFailLoad(
    ShopBranchState branchState, FailLoadShopBranchesAction action) {
  return branchState.copyWith(
    loading: false,
    failLoad: true,
    errorLoad: false,
  );
}

ShopBranchState _onErrorLoad(
    ShopBranchState branchState, ErrorLoadShopBranchesAction action) {
  return branchState.copyWith(
    loading: false,
    failLoad: false,
    errorLoad: true,
  );
}
