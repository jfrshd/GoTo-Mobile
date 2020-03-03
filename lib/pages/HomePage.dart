import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gotomobile/models/post.dart';
import 'package:gotomobile/services/postsService.dart';
import 'package:gotomobile/widgets/colorLoader/ColorLoader4.dart';
import 'package:gotomobile/widgets/drawer/CustomDrawer.dart';
import 'package:gotomobile/widgets/post/PostItem.dart';

class HomePage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();

  bool _isSearch = false;
  bool _moreToLoad = true;
  bool _error = false;
  bool _loadingPosts = false;
  int _currentpage = 1;

  List<Post> _posts = new List();
  List<Post> _tmpAllPosts = new List();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    if (_posts.length == 0) loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return _createTryAgainPage();
    }

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          key: _scaffoldKey,
          drawer: CustomDrawer(),
          appBar: _createAppBar(),
          body: _posts.length == 0
              ? Center(
                  child: ColorLoader4(
                      color1: Colors.blue,
                      color2: Colors.blue[300],
                      color3: Colors.blue[100]),
                )
              : Column(children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _posts.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == _posts.length) {
                          return null;
                          return (_moreToLoad && !_isSearch)
                              ? Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    //TODO: Choose ProgressIndicator
                                    child: ColorLoader4(
                                        color1: Colors.blue,
                                        color2: Colors.blue[300],
                                        color3: Colors.blue[100]),
                                  ),
                                )
                              : Container();
                        } else
                          return PostItem(index, _posts[index], _toggleSearch);
                      },
                    ),
                  ),
                ]),
        ));
  }

  AppBar _createAppBar() {
    return _isSearch
        ? AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            actions: <Widget>[
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.search),
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: TextField(
                                    autofocus: true,
                                    decoration: new InputDecoration(
                                        hintText: "Company Name",
                                        hintStyle: TextStyle(
                                            fontSize: 20,
                                            color: Color(0x88FFFFFF)),
                                        labelStyle: new TextStyle(
                                            color: const Color(0xFF424242)),
                                        border: InputBorder.none),
                                    // decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid))),
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                    onChanged: (text) {
                                      setState(() {
                                        _tmpAllPosts = []..addAll(_posts);
                                        _posts.where((post) => post.shop.name
                                            .toLowerCase()
                                            .contains(text.toLowerCase()));
                                      });
                                    },
                                  ))),
                          IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                _toggleSearch();
                              }),
                        ],
                      )))
            ],
          )
        : AppBar(
            automaticallyImplyLeading: true,
            centerTitle: true,
            title: Text("GoTo"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    _isSearch = true;
                  });
                },
              )
            ],
          );
  }

  Widget _createTryAgainPage() {
    return Scaffold(
      appBar: _createAppBar(),
      drawer: CustomDrawer(),
      body: !_loadingPosts
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                  Center(
                      child: Text(
                    "Please check your internet connection",
                  )),
                  RaisedButton(
                    child: Text("Try Again"),
                    onPressed: () {
                      loadPosts();
                      setState(() {
                        _loadingPosts = true;
                      });
                    },
                  )
                ])
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(),
                      ColorLoader4(
                          color1: Colors.blue,
                          color2: Colors.blue[300],
                          color3: Colors.blue[100]),
                    ],
                  )
                ]),
    );
  }

  loadPosts() {
    setState(() {
      _error = false;
      _loadingPosts = true;
    });

    getPosts(page: _currentpage).then((response) {
      final parsed = Map<String, dynamic>.from(json.decode(response.body));
      if (parsed["success"] == "true") {
        final posts = parsed['posts']['data']
            .map<Post>((json) => Post.fromJson(json))
            .toList();
        print("posts");
        print(posts.runtimeType);
        print(posts);
        setState(() {
          _error = false;
          _loadingPosts = false;
          _posts.addAll(posts);
          _currentpage += 1;
          if (_currentpage > parsed['posts']["last_page"]) _moreToLoad = false;
        });
      }
    }).catchError((e) {
      print("getPosts error: ");
      print(e);
      setState(() {
        _error = true;
        _loadingPosts = false;
      });
    });
  }

  void _toggleSearch() {
    _isSearch = false;
    setState(() {
      _posts = []..addAll(_tmpAllPosts);
    });
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("reach the bottom");
      //TODO: Check if it's better to continuously load pages or wait for scroll.
      if (!_loadingPosts && !_isSearch) {
        _loadingPosts = true;
        if (_moreToLoad) {
          loadPosts();
        }
      }
    }

    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("reach the top");
    }
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
