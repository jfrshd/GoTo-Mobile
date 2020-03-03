import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gotomobile/models/category.dart';
import 'package:gotomobile/pages/ErrorPage.dart';
import 'package:gotomobile/routes.dart';
import 'package:gotomobile/services/categoriesService.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/utils/SharedPreferencesHelper.dart';
import 'package:gotomobile/widgets/colorLoader/ColorLoader4.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../api.dart';

class ChooseCategoriesPage extends StatefulWidget {
  @override
  _ChooseCategoriesPageState createState() => _ChooseCategoriesPageState();
}

class _ChooseCategoriesPageState extends State<ChooseCategoriesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isFirstTime;
  bool _error = false;
  bool _loadingCategories = false;

  List<Category> _categories = List<Category>();

  void initState() {
    super.initState();
    if (_categories.length == 0) loadCategories();
  }

  AppBar createAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text('Favorites'),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            Alert(
                    image: Image.asset('assets/images/info.png'),
                    title: "",
                    buttons: [],
                    context: context,
//                        type: AlertType.none,
                    style: AlertStyle(
                        animationType: AnimationType.grow,
                        titleStyle: TextStyle(fontSize: 0),
                        isCloseButton: false,
                        backgroundColor: Colors.blue,
                        descStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        )),
                    desc: Constants.categoriesPageDesc)
                .show();
          },
          icon: Icon(Icons.info),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstTime == null) {
      checkFirstTime();
    }
    if (_error) {
      return ErrorPage(
          createAppBar(), Constants.categoriesError, loadCategories);
    }

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: createAppBar(),
        body: _categories.length == 0
            ? Center(
                child: ColorLoader4(
                    color1: Colors.blue,
                    color2: Colors.blue[300],
                    color3: Colors.blue[100]))
            : ListView.builder(
                padding: EdgeInsets.all(1),
                itemCount: _categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: index == _categories.length - 1
                        ? EdgeInsets.only(bottom: 70)
                        : null,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            _categories[index].selected =
                                !_categories[index].selected;
                          });
                        },
                        child: Container(
                            decoration: !_categories[index].selected
                                ? BoxDecoration(color: Colors.white)
                                : BoxDecoration(
                                    color: Color.fromRGBO(64, 128, 255, 0.2)),
                            child: ListTile(
                              title: Text(_categories[index].name),
                              trailing: Container(
                                /* decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),*/
                                height: 30,
                                width: 30,
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: _categories[index].selected
                                      ? Icon(
                                          Icons.star,
                                          size: 30.0,
                                          color: Colors.blue,
                                        )
                                      : Icon(
                                          Icons.star_border,
                                          size: 30.0,
                                          color: Colors.blue,
                                        ),
                                ),
                              ),
                              leading: _categories[index].thumbnail == null
                                  ? SizedBox.fromSize(
                                      size: Size(40, 40),
                                      child: Container(),
                                    )
                                  : SizedBox.fromSize(
                                      size: Size(40, 40),
                                      child: SvgPicture.network(
                                        API.serverAddress +
                                            "/" +
                                            _categories[index]
                                                .thumbnail
                                                .replaceFirst("public/", ""),
                                        placeholderBuilder: (context) =>
                                            CircularProgressIndicator(),
                                      ),
                                    ),
                            ))),
                  );
                }),
        floatingActionButton: _categories.length == 0
            ? null
            : FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () {
//                              checkConnectivity();
                  if (_categories.where((c) => c.selected).toList().length >=
                      3) {
                    saveCategories();
                  } else {
                    showChooseAtLeastThree();
                  }
                },
                child: Icon(Icons.arrow_forward)));
  }

  void loadCategories() {
    setState(() {
      _loadingCategories = true;
      _error = false;
    });
    getCategories().then((response) {
      final parsed = Map<String, dynamic>.from(json.decode(response.body));
      if (parsed["success"] == "true") {
        final categories = parsed['categories']
            .map<Category>((json) => Category.fromJson(json))
            .toList();

        setState(() {
          _error = false;
          _loadingCategories = false;
          _categories = categories;
        });
      }
    }).catchError((e) {
      print("getCategories error: ");
      print(e);
      setState(() {
        _error = true;
        _loadingCategories = false;
      });
    });
  }

  void saveCategories() {
    updateSelectedCategories(_categories
            .where((category) => category.selected)
            .map<int>((category) => category.id)
            .toList())
        .then((response) {
      final parsed = Map<String, dynamic>.from(json.decode(response.body));
      if (parsed["success"] == "true") {
        if (_isFirstTime) {
          Navigator.pushReplacementNamed(context, Routes.regionsRoute);
        } else {
          Navigator.pop(context);
        }
      } else {
        showError("Failed");
      }
    }).catchError((e) {
      print("saveCategories error: ");
      print(e);
      showError("Failed");
    });
  }

  void showError(String e) {
    final snackBar = SnackBar(
      content: Text(e),
      duration: Duration(seconds: 2),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void showChooseAtLeastThree() {
    final snackBar = SnackBar(
      content: Text(Constants.atLeastThree),
      duration: Duration(seconds: 2),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void checkFirstTime() async {
    _isFirstTime =
        await SharedPreferencesHelper.getBool(Constants.firstTimeCode);
  }
}
