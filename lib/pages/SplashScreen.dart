import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gotomobile/models/account.dart';
import 'package:gotomobile/redux/actions/account_actions.dart';
import 'package:gotomobile/redux/actions/category_actions.dart';
import 'package:gotomobile/redux/actions/region_actions.dart';
import 'package:gotomobile/redux/states/app_state.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/utils/SharedPreferencesHelper.dart';
import 'package:redux/redux.dart';

import 'ChooseCategoriesPage.dart';
import 'HomePage.dart';

class SplashScreen extends StatefulWidget {
  final Store<AppState> store;

  SplashScreen(this.store);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isFirstLaunch, going = false;
  Widget _firstPage;

  void checkFirstTime() async {
    _isFirstLaunch =
        await SharedPreferencesHelper.getBool(Constants.firstTimeCode);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstLaunch == null) {
      checkFirstTime();
      return Container();
    }
    _firstPage = _isFirstLaunch ? ChooseCategoriesPage() : HomePage();

    return StoreConnector<AppState, _ViewModel>(
      converter: (store) {
        return _ViewModel.fromStore(store);
      },
      builder: (BuildContext context, _ViewModel vm) {
        if (!vm.account.authenticating &&
            vm.account.authToken != '' &&
            !vm.account.firebasing &&
            vm.account.accountID != -1 &&
            !vm.switchingSplashScreen) {
          vm.fetchCategories();
          vm.fetchRegions();
          vm.switchSplashScreen();
          new Future.delayed(Duration(milliseconds: 500), () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => _firstPage));
          });
        }
        return Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'GoTo',
                            style: TextStyle(
                              fontSize: 50,
                              color: Colors.blue[100],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
//                          Container(
//                            margin: EdgeInsets.only(top: 30),
//                            child: CircularProgressIndicator(
//                              backgroundColor: Colors.white,
//                            ),
//                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 70),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        'Powered by IBDAA',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue[300],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final bool switchingSplashScreen;
  final Account account;
  final Function() switchSplashScreen;
  final void Function() fetchCategories;
  final void Function() fetchRegions;

  _ViewModel({
    @required this.switchingSplashScreen,
    @required this.account,
    @required this.switchSplashScreen,
    @required this.fetchCategories,
    @required this.fetchRegions,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      switchingSplashScreen: store.state.switchingSplashScreen,
      account: store.state.account,
      switchSplashScreen: () => store.dispatch(SwitchingSplashScreenAction()),
      fetchCategories: () => store.dispatch(fetchCategoriesAction()),
      fetchRegions: () => store.dispatch(fetchRegionsAction()),
    );
  }
}
