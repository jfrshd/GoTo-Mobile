import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gotomobile/models/post.dart';
import 'package:gotomobile/models/shop.dart';
import 'package:gotomobile/services/postsService.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/widgets/post/PostItem.dart';

import '../ErrorPage.dart';

class PostsTab extends StatefulWidget {
  final Shop shop;

  PostsTab(this.shop);

  @override
  _PostsTabState createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _loadingPosts = false;
  bool _error = false;
  List<Post> _posts = List<Post>();

  void initState() {
    super.initState();
    if (_posts.length == 0) _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return ErrorPage(Constants.postsError, _loadPosts);
    }
    return Container(
      color: Colors.grey[100],
      child: _posts.length == 0
          ? Text('no posts found')
          : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _loadPosts,
              color: Theme.of(context).primaryColor,
              child: ListView.builder(
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    _posts[index].shop = widget.shop;
                    return PostItem(index, _posts[index], false);
                  }),
            ),
    );
  }

  Future<void> _loadPosts() {
    _refreshIndicatorKey.currentState?.show();
    setState(() {
      _loadingPosts = true;
      _error = false;
    });
    return getShopPosts(shopID: widget.shop.id).then((response) {
      final parsed = Map<String, dynamic>.from(json.decode(response.body));
      if (parsed["status"] == "success") {
        final posts = parsed['posts']["data"]
            .map<Post>((json) => Post.fromJson(json))
            .toList();

        setState(() {
          _error = false;
          _loadingPosts = false;
          _posts = posts;
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
}
