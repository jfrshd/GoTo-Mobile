//import 'dart:html' show HttpRequest;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gotomobile/pages/ChooseRegionsPage.dart';
import 'package:gotomobile/pages/HomePage.dart';
import 'package:gotomobile/routes.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/utils/SharedPreferencesHelper.dart';

import 'Pages/ChooseCategoriesPage.dart';
import 'firebase_notification_handler.dart';

void main() {
  runApp(MyApp());
}

/// This Widget is the main application widget.
class MyApp extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    if (_isFirstLaunch == null) {
      checkFirstTime();
      return MaterialApp(home: Scaffold());
    }
    _firstPage = _isFirstLaunch ? ChooseCategoriesPage() : HomePage();

    new FirebaseNotifications().setUpFirebase();

    return MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.blue,
            pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            }),
            // Define the default brightness and colors.

            /* brightness: Brightness.dark,
          primaryColor: Colors.lightBlue[800],
          accentColor: Colors.cyan[600],*/

            // Define the default font family.
//          fontFamily: 'Raleway',

            // Define the default TextTheme. Use this to specify the default
            // text styling for headlines, titles, bodies of text, and more.
//          textTheme: TextTheme(
//            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
//            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
//            body1: TextStyle(
////                fontSize: 25.0,
//              fontFamily: 'CenturyGothic',
////                fontWeight: FontWeight.bold
//            ),
//          ),
        ),
        home: _firstPage,
        routes: <String, WidgetBuilder>{
            Routes.categoriesRoute: (BuildContext context) =>
                ChooseCategoriesPage(),
            Routes.regionsRoute: (BuildContext context) => ChooseRegionsPage(),
            Routes.homePageRoute: (BuildContext context) => HomePage(),
        });
    }
}
