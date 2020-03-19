import 'package:gotomobile/redux/states/app_state.dart';

import 'account_reducer.dart';
import 'category_reducer.dart';
import 'region_reducer.dart';

AppState appReducer(AppState state, action) => AppState(
	switchingSplashScreen: screenReducer(state.switchingSplashScreen, action),
      account: accountReducer(state.account, action),
      categoryState: categoryReducer(state.categoryState, action),
      regionState: regionReducer(state.regionState, action),
    );
