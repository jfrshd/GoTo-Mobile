import 'package:gotomobile/models/models.dart';
import 'package:gotomobile/redux/actions/account_actions.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/utils/SharedPreferencesHelper.dart';
import 'package:redux/redux.dart';

final accountReducer = combineReducers<Account>([
  TypedReducer<Account, SuccessAuthAction>(_successAuth),
  TypedReducer<Account, LoadingAuthAction>(_loading),
  TypedReducer<Account, FailAuthAction>(_fail),
  TypedReducer<Account, ErrorAuthAction>(_error),
  TypedReducer<Account, UpdateFirebaseAction>(_successFirebase),
]);

Account _successAuth(Account accountState, SuccessAuthAction action) {
  if (!action.fromSharedPref) {
    SharedPreferencesHelper.setString(
      Constants.authToken,
      action.authTokenPayload,
    );
  }

  return accountState.copyWith(authToken: action.authTokenPayload);
}

Account _successFirebase(Account accountState, UpdateFirebaseAction action) {
  SharedPreferencesHelper.setInt(Constants.accountID, action.accountIDPayload);
  return accountState.copyWith(
      accountID: action.accountIDPayload, authenticating: false);
}

Account _loading(Account accountState, LoadingAuthAction action) {
  return accountState.copyWith(authenticating: true);
}

Account _fail(Account accountState, FailAuthAction action) {
  return accountState.copyWith(authenticating: false);
}

Account _error(Account accountState, ErrorAuthAction action) {
  return accountState.copyWith(authenticating: false);
}
