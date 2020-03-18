import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:gotomobile/pages/FiltersPage.dart';
import 'package:gotomobile/widgets/PostsList.dart';
import 'package:gotomobile/widgets/ShopsList.dart';
import 'package:gotomobile/widgets/drawer/CustomDrawer.dart';

class HomePage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<HomePage> {
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  bool _isSearch = false;
  bool _isFilter = false;
  String searchText = 'GoTo';
  bool delayEnded = false;
  bool forceFocus = false;

  void initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.path);
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        print("deepLink.path");
        print(deepLink.path);
        Navigator.pushNamed(context, deepLink.path);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  @override
  void initState() {
    super.initState();

    this.initDynamicLinks();

    _focusNode.addListener(() {
      setState(() {
        _isSearch = _focusNode.hasFocus;
        if (!delayEnded) {
          searchText = '';
          forceFocus = true;
          delayEnded = true;
        }
      });
    });
    Future.delayed(const Duration(milliseconds: 5000), () {
      setState(() {
        searchText = '';
        delayEnded = true;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        drawer: CustomDrawer(),
        appBar: _createAppBar(),
        body: _isSearch
            ? new ShopsList(searchText)
            : _isFilter ? new FiltersPage() : new PostsList(),
      ),
    );
  }

  AppBar _createAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      centerTitle: true,
      actions: <Widget>[
        _isFilter
            ? Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Stack(children: [
                              Center(
                                child: Text(
                                  'Filters',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "ProductSans",
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ])),
                      ),
                    ],
                  ),
                ))
            : Expanded(
                flex: 1,
                child: Padding(
                    padding: EdgeInsets.only(left: 50),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Stack(children: [
                                delayEnded
                                    ? SizedBox.fromSize(size: Size(0, 0))
                                    : Center(
                                        child: Text(
                                          searchText,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: "ProductSans",
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 1000),
                                  opacity: delayEnded ? 1.0 : 0.0,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[500],
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                    ),
                                    child: Center(
                                      child: TextField(
                                        controller: _textEditingController,
                                        cursorColor: Colors.grey,
                                        focusNode: _focusNode,
                                        autofocus: forceFocus,
                                        textAlign: _isSearch
                                            ? TextAlign.center
                                            : TextAlign.center,
                                        decoration: !_isSearch && !forceFocus
                                            ? InputDecoration(
                                                hintText: "Search Shops",
                                                hintStyle: TextStyle(
                                                    fontSize: 20,
                                                    color: Color(0x88FFFFFF)),
                                                labelStyle: new TextStyle(
                                                    color: Color(0xFF424242)),
                                                border: InputBorder.none)
                                            : InputDecoration(
                                                border: InputBorder.none),
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                        onSubmitted: (text) {
                                          // TODO: onSubmit
                                        },
                                        onChanged: (text) {
                                          setState(() {
                                            searchText = text;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ])),
                        ),
                      ],
                    ))),
        _isSearch
            ? Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: _toggleSearch,
                ),
              )
            : _isFilter
            ? IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _isFilter = false;
            });
          },
        )
            : IconButton(
          icon: Icon(
            Icons.filter_list,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        FiltersPage()));
//                      setState(() {
//                        _isFilter = true;
//                        delayEnded = true;
//                      });
          },
        ),
      ],
    );
  }

///////////////////////////////////////////////////////////////////////////////////

  void _toggleSearch() {
    setState(() {
      searchText = '';
      _isSearch = false;
      forceFocus = false;
      _textEditingController.clear();
      _focusNode.unfocus();
    });
  }

  Future<bool> _onWillPop() async {
    if (_isSearch) {
      _toggleSearch();
      return false;
    } else {
      return true;
    }
  }
}
