import 'package:gotomobile/models/models.dart';
import 'package:gotomobile/redux/actions/account_actions.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/utils/SharedPreferencesHelper.dart';
import 'package:redux/redux.dart';

import '../../firebase_notification_handler.dart';

final accountReducer = combineReducers<Account>([
  TypedReducer<Account, SuccessAuthAction>(_successAuth),
  TypedReducer<Account, LoadingAuthAction>(_loading),
  TypedReducer<Account, FailAuthAction>(_fail),
  TypedReducer<Account, ErrorAuthAction>(_error),
  TypedReducer<Account, UpdateFirebaseAction>(_successFirebase),
  TypedReducer<Account, LoadingFirebaseAction>(_loadingFirebase),
  TypedReducer<Account, ToggleFirstLaunchAction>(_toggleFirstLaunch),
]);
final screenReducer = combineReducers<bool>([
  TypedReducer<bool, SwitchingSplashScreenAction>(_switching),
]);

Account _successAuth(Account accountState, SuccessAuthAction action) {
  if (!action.fromSharedPref) {
    SharedPreferencesHelper.setString(
      Constants.authToken,
      action.authTokenPayload,
    );
  }
  new FirebaseNotifications().setUpFirebase();

  return accountState.copyWith(
      authToken: action.authTokenPayload, authenticating: false);
}

bool _switching(bool switchingState, SwitchingSplashScreenAction action) {
  return true;
}

Account _toggleFirstLaunch(
    Account accountState, ToggleFirstLaunchAction action) {
  SharedPreferencesHelper.setBool(
    Constants.firstTimeCode,
    action.isFirstTime,
  );
  return accountState.copyWith(isFirstLaunch: action.isFirstTime);
}

Account _successFirebase(Account accountState, UpdateFirebaseAction action) {
  SharedPreferencesHelper.setInt(Constants.accountID, action.accountIDPayload);
  return accountState.copyWith(
      accountID: action.accountIDPayload, firebasing: false);
}

Account _loading(Account accountState, LoadingAuthAction action) {
  return accountState.copyWith(authenticating: true);
}

Account _loadingFirebase(Account accountState, LoadingFirebaseAction action) {
  return accountState.copyWith(firebasing: true);
}

Account _fail(Account accountState, FailAuthAction action) {
  return accountState.copyWith(authenticating: false);
}

Account _error(Account accountState, ErrorAuthAction action) {
  return accountState.copyWith(authenticating: false);
}
