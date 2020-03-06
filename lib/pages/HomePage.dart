import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gotomobile/models/post.dart';
import 'package:gotomobile/pages/ErrorPage.dart';
import 'package:gotomobile/services/postsService.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/widgets/colorLoader/ColorLoader4.dart';
import 'package:gotomobile/widgets/drawer/CustomDrawer.dart';
import 'package:gotomobile/widgets/post/PostItem.dart';

class HomePage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<HomePage> {
  ScrollController _scrollController = new ScrollController();
  FocusNode _focusNode = FocusNode();

  bool _isSearch = false;
  bool _moreToLoad = true;
  bool _error = false;
  bool _errorLoadingMore = false;
  bool _loadingPosts = false;
  int _currentpage = 1;

  List<Post> _posts = new List();
  List<Post> _tmpAllPosts = new List();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isSearch = _focusNode.hasFocus;
      });
    });
    _scrollController.addListener(_scrollListener);
    if (_posts.length == 0) loadPosts();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return ErrorPage(_createAppBar(), Constants.postsError, loadPosts,
          drawer: CustomDrawer());
    }

    if (!_isSearch) {
      _posts = _tmpAllPosts;
    }
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          drawer: CustomDrawer(),
          appBar: _createAppBar(),
          body: _posts.length == 0
              ? Center(
                  child: ColorLoader4(
                      color1: Colors.blue,
                      color2: Colors.blue[300],
                      color3: Colors.blue[100]),
                )
              : GestureDetector(
                  onTap: () {
//                    FocusScopeNode currentFocus = FocusScope.of(context);
                    _focusNode.unfocus();
                  },
                  child: Column(children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _posts.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == _posts.length) {
                            if (_moreToLoad && !_isSearch) {
                              if (_loadingPosts)
                                return Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    //TODO: Choose ProgressIndicator
                                    child: ColorLoader4(
                                        color1: Colors.blue,
                                        color2: Colors.blue[300],
                                        color3: Colors.blue[100]),
                                  ),
                                );
                              else if (_errorLoadingMore)
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child:
                                          Text(Constants.postsPaginationError)),
                                );
                            }
                            return Container();
                          } else
                            return PostItem(
                                index, _posts[index], _toggleSearch);
                        },
                      ),
                    ),
                  ]),
                ),
        ));
  }

  AppBar _createAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      centerTitle: true,
      actions: <Widget>[
        Expanded(
            flex: 1,
            child: Padding(
                padding: EdgeInsets.only(left: 50),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: TextField(
                              cursorColor: Colors.grey,
                              focusNode: _focusNode,
                              textAlign:
                                  _isSearch ? TextAlign.left : TextAlign.center,
                              decoration: !_isSearch
                                  ? InputDecoration(
//                                      hintText: "GoTo",
                                      hintText: "Search",
                                      hintStyle: TextStyle(
                                          fontSize: 20,
                                          color: Color(0x88FFFFFF)),
                                      labelStyle: new TextStyle(
                                          color: Color(0xFF424242)),
                                      border: InputBorder.none)
                                  : InputDecoration(),
                              // decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid))),
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                              onChanged: (text) {
                                setState(() {
                                  // TODO: show text no results found
                                  if (text == '') {
                                    _posts = _tmpAllPosts;
                                    return;
                                  } else if (_posts.length == 0) {
                                    _posts = _tmpAllPosts;
                                  }
                                  _posts = _posts
                                      .where((post) =>
                                          post.shop.name
                                              .toLowerCase()
                                              .contains(text.toLowerCase()) ||
                                          post.description
                                              .toLowerCase()
                                              .contains(text.toLowerCase()))
                                      .toList();
                                });
                              },
                            ))),
                  ],
                ))),
        IconButton(
          icon: Icon(
            Icons.filter_list,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
    );
//         AppBar(
//            automaticallyImplyLeading: true,
//            centerTitle: true,
//            title: Text("GoTo"),
//            actions: <Widget>[
//              IconButton(
//                icon: Icon(Icons.search),
//                onPressed: () {
//                  setState(() {
//                    _isSearch = true;
//                  });
//                },
//              )
//            ],
//          );
  }

  loadPosts({bool error}) {
    setState(() {
      _error = false;
      _loadingPosts = true;
    });

    getPosts(page: _currentpage).then((response) {
      final parsed = Map<String, dynamic>.from(json.decode(response.body));
      if (parsed["status"] == "success") {
        final posts = parsed['posts']['data']
            .map<Post>((json) => Post.fromJson(json))
            .toList();

        setState(() {
          _error = false;
          _errorLoadingMore = false;
          _loadingPosts = false;
          _posts.addAll(posts);
          _tmpAllPosts.addAll(posts);
          _currentpage += 1;
          if (_currentpage > parsed['posts']["last_page"]) _moreToLoad = false;
        });
      }
    }).catchError((e) {
      print("getPosts error: ");
      print(e);
      setState(() {
        _loadingPosts = false;
        if (_currentpage == 1)
          _error = true;
        else {
          _errorLoadingMore = true;
        }
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
