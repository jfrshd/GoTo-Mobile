import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gotomobile/models/post.dart';
import 'package:gotomobile/models/shop.dart';
import 'package:gotomobile/services/postsService.dart';
import 'package:gotomobile/utils/Constants.dart';
import 'package:gotomobile/widgets/post/PostItem.dart';

import '../ErrorPage.dart';

class PostsTab extends StatefulWidget {
  Shop shop;

  PostsTab(this.shop);

  @override
  _PostsTabState createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
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
      return ErrorPage(null, Constants.postsError, _loadPosts);
    }
    return Container(
      color: Colors.grey[100],
      child: _posts.length == 0
          ? Text('no posts found')
          : ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                _posts[index].shop = widget.shop;
                return PostItem(index, _posts[index], () {});
              }),
    );
  }

  void _loadPosts() {
    setState(() {
      _loadingPosts = true;
      _error = false;
    });
    getShopPosts(shopID: widget.shop.id).then((response) {
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
