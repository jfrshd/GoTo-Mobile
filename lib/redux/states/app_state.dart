import 'dart:convert';

import 'package:gotomobile/models/account.dart';
import 'package:gotomobile/redux/states/post_state.dart';
import 'package:gotomobile/redux/states/region_state.dart';
import 'package:gotomobile/redux/states/search_state.dart';
import 'package:gotomobile/redux/states/shop_branch_state.dart';
import 'package:gotomobile/redux/states/shop_post_state.dart';
import 'package:gotomobile/redux/states/shop_state.dart';
import 'package:gotomobile/redux/states/states.dart';
import 'package:meta/meta.dart';

import 'home_appbar_state.dart';

@immutable
class AppState {
  final bool switchingSplashScreen;
  final Account account;
  final CategoryState categoryState;
  final RegionState regionState;
  final PostState postState;
  final ShopState shopState;
  final ShopBranchState shopBranchState;
  final ShopPostState shopPostState;
  final SearchState searchState;
  final HomeState homeState;

  const AppState({
    this.switchingSplashScreen = false,
    this.account = const Account(),
    this.categoryState = const CategoryState(),
    this.regionState = const RegionState(),
    this.postState = const PostState(),
    this.shopState = const ShopState(),
    this.shopBranchState = const ShopBranchState(),
    this.shopPostState = const ShopPostState(),
    this.searchState = const SearchState(),
    this.homeState = const HomeState(),
  });

	dynamic toJson() =>
		{
//        'switchingSplashScreen': switchingSplashScreen,
//        'account': account,
//        'categoryState': categoryState,
//        'regionState': regionState,
//        'postState': postState,
//        'shopState': shopState,
//        'shopBranchState': shopBranchState,
//        'shopPostState': shopPostState,
			'searchState': searchState,
			'homeState': homeState,
		};

	@override
	String toString() {
		return 'AppState';
		return 'AppState: ${JsonEncoder.withIndent('  ').convert(this)}';
	}
}
