import 'package:gotomobile/models/account.dart';
import 'package:gotomobile/redux/states/post_state.dart';
import 'package:gotomobile/redux/states/region_state.dart';
import 'package:gotomobile/redux/states/shop_branch_state.dart';
import 'package:gotomobile/redux/states/shop_post_state.dart';
import 'package:gotomobile/redux/states/shop_state.dart';
import 'package:gotomobile/redux/states/states.dart';
import 'package:meta/meta.dart';

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

  const AppState({
    this.switchingSplashScreen = false,
    this.account = const Account(),
    this.categoryState = const CategoryState(),
    this.regionState = const RegionState(),
    this.postState = const PostState(),
    this.shopState = const ShopState(),
    this.shopBranchState = const ShopBranchState(),
    this.shopPostState = const ShopPostState(),
  });

  dynamic toJson() => {
//        'switchingSplashScreen': switchingSplashScreen,
//        'account': account,
//        'categoryState': categoryState,
//        'regionState': regionState,
//        'postState': postState,
//        'shopState': shopState,
//        'shopBranchState': shopBranchState,
        'shopPostState': shopPostState,
      };

  @override
  String toString() {
    return 'AppState';
//    return 'AppState: ${JsonEncoder.withIndent('  ').convert(this)}';
  }
}
