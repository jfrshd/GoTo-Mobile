import 'dart:convert';

import 'package:gotomobile/redux/states/app_state.dart';
import 'package:gotomobile/services/account_service.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/utils/SharedPreferencesHelper.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class SuccessAuthAction {
  final bool fromSharedPref;
  final String authTokenPayload;

  SuccessAuthAction(this.fromSharedPref, this.authTokenPayload);
}

class UpdateFirebaseAction {
  final int accountIDPayload;

  UpdateFirebaseAction(this.accountIDPayload);
}

class LoadingAuthAction {}

class FailAuthAction {}

class ErrorAuthAction {}

class LoadingFirebaseAction {}

class FailFirebaseAction {}

class ErrorFirebaseAction {}

class SwitchingSplashScreenAction {}

class CheckFirstLaunchAction {}

class ToggleFirstLaunchAction {
  final bool isFirstTime;

  ToggleFirstLaunchAction(this.isFirstTime);
}

ThunkAction<AppState> authenticateAction() {
  return (Store<AppState> store) async {
    store.dispatch(LoadingAuthAction());

    String authToken =
        await SharedPreferencesHelper.getString(Constants.authToken);
    if (authToken != "") {
      store.dispatch(SuccessAuthAction(true, authToken));
    } else {
      AccountService.getAuthToken().then((response) {
        if (response.statusCode == 200) {
          final parsed = json.decode(response.body);
          if (parsed.containsKey("success")) {
            String authToken = parsed["success"]["token"];
            store.dispatch(SuccessAuthAction(false, authToken));
          }
        } else if (response.statusCode == 401) {
          // Unauthorized
          final parsed = json.decode(response.body);
          if (parsed.containsKey("error")) {
            store.dispatch(FailAuthAction());
          }
        }
      }).catchError((error) {
        print('getAuthToken error: ');
        print(error);
        store.dispatch(ErrorAuthAction());
      });
    }
  };
}

ThunkAction<AppState> firebaseSetupAction(bool fromSharedPref,
    {String firebaseToken, int accountID}) {
  return (Store<AppState> store) async {
    if (fromSharedPref)
      store.dispatch(UpdateFirebaseAction(accountID));
    else
      AccountService.updateFirebaseToken(
          store.state.account.authToken, firebaseToken)
          .then((response) {
        final parsed = Map<String, dynamic>.from(json.decode(response.body));
        if (parsed['status'] == 'success' || parsed['status'] == 'fail') {
          store.dispatch(UpdateFirebaseAction(parsed["account_id"]));
        }
      }).catchError((error) {
        print('updateFirebaseToken error: ');
        print(error);
        store.dispatch(ErrorFirebaseAction());
      });
  };
}
