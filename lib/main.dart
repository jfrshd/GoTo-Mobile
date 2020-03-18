//import 'dart:html' show HttpRequest;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gotomobile/pages/ChooseRegionsPage.dart';
import 'package:gotomobile/pages/HomePage.dart';
import 'package:gotomobile/redux/actions/account_actions.dart';
import 'package:gotomobile/redux/actions/category_actions.dart';
import 'package:gotomobile/redux/reducers/reducers.dart';
import 'package:gotomobile/routes.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/utils/SharedPreferencesHelper.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'Pages/ChooseCategoriesPage.dart';
import 'firebase_notification_handler.dart';
import 'redux/states/app_state.dart';

final Store<AppState> store = Store<AppState>(
  appReducer,
  initialState: AppState(),
  middleware: [
    thunkMiddleware,
    new LoggingMiddleware.printer()
//      SearchMiddleware(GithubClient()),
//      EpicMiddleware<SearchState>(SearchEpic(GithubClient())),
  ],
);

void main() async {
  print('Initial state: ${store.state}');

  runApp(MyApp(store));
}

/// This Widget is the main application widget.
class MyApp extends StatefulWidget {
  final Store<AppState> store;

  MyApp(this.store);

  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool _isFirstLaunch;
  Widget _firstPage;

  void checkFirstTime() async {
    _isFirstLaunch =
        await SharedPreferencesHelper.getBool(Constants.firstTimeCode);
    setState(() {});
  }

  initCalls() {
    widget.store.dispatch(authenticateAction());
    widget.store.dispatch(fetchCategoriesAction());
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstLaunch == null) {
      checkFirstTime();
      return MaterialApp(home: Scaffold());
    }
    _firstPage = _isFirstLaunch ? ChooseCategoriesPage() : HomePage();

//    new Future(initCalls);
    initCalls();

    new FirebaseNotifications().setUpFirebase();

    return StoreProvider<AppState>(
      store: widget.store,
      child: MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.blue,
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            }),
            fontFamily: 'ProductSans',
          ),
          home: _firstPage,
          routes: <String, WidgetBuilder>{
            Routes.categoriesRoute: (BuildContext context) =>
                ChooseCategoriesPage(),
            Routes.regionsRoute: (BuildContext context) => ChooseRegionsPage(),
            Routes.homePageRoute: (BuildContext context) => HomePage(),
          }),
    );
  }
}
