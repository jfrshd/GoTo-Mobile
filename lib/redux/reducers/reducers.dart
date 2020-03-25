import 'package:gotomobile/redux/reducers/post_reducer.dart';
import 'package:gotomobile/redux/reducers/shop_branch_reducer.dart';
import 'package:gotomobile/redux/reducers/shop_post_reducer.dart';
import 'package:gotomobile/redux/states/app_state.dart';

import 'account_reducer.dart';
import 'category_reducer.dart';
import 'region_reducer.dart';
import 'shop_reducer.dart';

AppState appReducer(AppState state, action) => AppState(
      switchingSplashScreen: screenReducer(state.switchingSplashScreen, action),
      account: accountReducer(state.account, action),
      categoryState: categoryReducer(state.categoryState, action),
      regionState: regionReducer(state.regionState, action),
      postState: postReducer(state.postState, action),
      shopState: shopReducer(state.shopState, action),
      shopBranchState: shopBranchReducer(state.shopBranchState, action),
      shopPostState: shopPostReducer(state.shopPostState, action),
    );
