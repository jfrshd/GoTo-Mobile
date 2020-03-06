import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gotomobile/models/region.dart';
import 'package:gotomobile/services/regionsService.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/utils/SharedPreferencesHelper.dart';
import 'package:gotomobile/widgets/colorLoader/ColorLoader4.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../api.dart';
import '../routes.dart';
import 'ErrorPage.dart';

class ChooseRegionsPage extends StatefulWidget {
  @override
  _ChooseRegionsPageState createState() => _ChooseRegionsPageState();
}

class _ChooseRegionsPageState extends State<ChooseRegionsPage> {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<
        ScaffoldState>();

    bool _isFirstLaunch = true;
    bool _error = false;
    bool _loadingRegions = false;

    static List<Region> _regions = List<Region>();

    void initState() {
        super.initState();
        if (_regions.length == 0) loadRegions();
    }

  AppBar createAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text('Regions'),
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
                    desc: Constants.regionsPageDesc)
                .show();
          },
          icon: Icon(Icons.info),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
      if (_isFirstLaunch) {
          checkFirstTime();
      }
      if (_error) {
          return ErrorPage(createAppBar(), Constants.regionsError, loadRegions);
      }

    List<Widget> regionsImgWidgets = new List<Widget>();
    _regions.forEach((region) => regionsImgWidgets.add(SvgPicture.network(
          API.serverAddress + "/" + region.svg.replaceFirst("public/", ""),
          width: MediaQuery.of(context).size.width / 2.5,
          height: MediaQuery.of(context).size.height / 2.5,
          color: region.selected ? region.color : Colors.black12,
        )));

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: createAppBar(),
        body: _regions.length == 0
            ? Center(
                child: ColorLoader4(
                    color1: Colors.blue,
                    color2: Colors.blue[300],
                    color3: Colors.blue[100]))
            : Container(
                height: double.infinity,
                child: Builder(
                    builder: (context) => Column(
                          children: <Widget>[
                            Center(
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                  child: Stack(
                                    children: regionsImgWidgets,
                                  )),
                            ),
                            Expanded(
                                child: ListView.builder(
                                    itemCount: _regions.length,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        margin: index == _regions.length - 1
                                            ? EdgeInsets.only(bottom: 70)
                                            : null,
                                        child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                _regions[index].selected =
                                                    !_regions[index].selected;
                                              });
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white),
                                                child: ListTile(
                                                  title: Text(
                                                      _regions[index].name),
                                                  trailing: Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white),
                                                    height: 30,
                                                    width: 30,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      child: _regions[index]
                                                              .selected
                                                          ? Icon(
                                                              Icons.star,
                                                              size: 30.0,
                                                              color:
                                                                  Colors.blue,
                                                            )
                                                          : Icon(
                                                              Icons.star_border,
                                                              size: 30.0,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                    ),
                                                  ),
                                                ))),
                                      );
                                    }))
                          ],
                        ))),
        floatingActionButton:
//        _regions.length == 0
//            ? null
//            :
            FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () {
                  if (_regions.where((r) => r.selected).toList().length >= 1) {
                    saveRegions();
                  } else {
                    showChooseAtLeastOne();
                  }
                },
                child: Icon(Icons.check)));
  }

  void loadRegions() {
    setState(() {
      _loadingRegions = true;
      _error = false;
    });
    getRegions().then((response) {
      final parsed = Map<String, dynamic>.from(json.decode(response.body));
      if (parsed["status"] == "success") {
          final regions = parsed['regions']
              .map<Region>((json) => Region.fromJson(json))
              .toList();

          setState(() {
              _error = false;
              _loadingRegions = false;
              _regions = regions;
          });
      }
    }).catchError((e) {
      print("getRegions error: ");
      print(e);
      setState(() {
        _error = true;
        _loadingRegions = false;
      });
    });
  }

  void saveRegions() {
    updateSelectedRegions(_regions
            .where((region) => region.selected)
            .map<int>((region) => region.id)
            .toList())
        .then((response) {
        final parsed = Map<String, dynamic>.from(json.decode(response.body));
        if (parsed["status"] == "success") {
            if (_isFirstLaunch) {
                setFirstTimeFalse();
                Navigator.pushReplacementNamed(context, Routes.homePageRoute);
            } else {
                Navigator.pop(context);
            }
        } else {
            showError("Failed");
        }
    }).catchError((e) {
      print("saveRegions error: ");
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

  void showNoInternet() {
    final snackBar = SnackBar(
      content: Text(Constants.noInternet),
      duration: Duration(seconds: 2),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void showChooseAtLeastOne() {
    final snackBar = SnackBar(
      content: Text(Constants.atLeastOne),
      duration: Duration(seconds: 2),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void checkFirstTime() async {
      _isFirstLaunch =
      await SharedPreferencesHelper.getBool(Constants.firstTimeCode);
  }

  setFirstTimeFalse() async {
    await SharedPreferencesHelper.setBool(Constants.firstTimeCode, false);
  }
}
