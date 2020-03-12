import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gotomobile/models/post.dart';
import 'package:gotomobile/pages/ErrorPage.dart';
import 'package:gotomobile/services/postsService.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/widgets/post/PostItem.dart';

import 'colorLoader/ColorLoader4.dart';

class PostsList extends StatefulWidget {
  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  ScrollController _scrollController = new ScrollController();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  bool _moreToLoad = true;
  bool _error = false;
  bool _errorLoadingMore = false;
  bool _loadingPosts = false;
  int _currentpage = 1;

  List<Post> _posts = List();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    if (_posts.length == 0) loadPosts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return ErrorPage(Constants.postsError, loadPosts);
    }
    return Container(
      child: _posts.length == 0
          ? Center(
              child: ColorLoader4(
                  color1: Colors.blue,
                  color2: Colors.blue[300],
                  color3: Colors.blue[100]),
            )
          : Column(children: <Widget>[
              Expanded(
                flex: 1,
                child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: loadPosts,
                  color: Theme.of(context).primaryColor,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _posts.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == _posts.length) {
                        if (_moreToLoad) {
                          if (_loadingPosts)
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                                  child: Text(Constants.postsPaginationError)),
                            );
                        }
                        return Container();
                      } else
                        return PostItem(index, _posts[index], true);
                    },
                  ),
                ),
              ),
            ]),
    );
  }

  Future<void> loadPosts({bool error}) {
    _refreshIndicatorKey.currentState?.show();
    setState(() {
      _error = false;
      _loadingPosts = true;
    });

    return getPosts(page: _currentpage).then((response) {
      final parsed = Map<String, dynamic>.from(json.decode(response.body));
      if (parsed["status"] == "success") {
        final posts = parsed['posts']['data']
            .map<Post>((json) => Post.fromJson(json))
            .toList();

        setState(() {
          _error = false;
          _errorLoadingMore = false;
          _loadingPosts = false;
          // TODO: bdna nshuf mawdo3 l filter krml ma yntz3 l sort on refresh aw pagination
          _posts.addAll(posts);
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

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("reach the bottom");
      //TODO: Check if it's better to continuously load pages or wait for scroll.
      if (!_loadingPosts) {
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
}
