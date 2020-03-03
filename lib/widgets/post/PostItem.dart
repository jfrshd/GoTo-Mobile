import 'package:flutter/material.dart';
import 'package:gotomobile/models/post.dart';
import 'package:gotomobile/widgets/post/PostBodyImages.dart';
import 'package:gotomobile/widgets/post/PostHeader.dart';

class PostItem extends StatelessWidget {
  final int index;
  final Post post;
  final Function toggleSearch;

  PostItem(this.index, this.post, this.toggleSearch);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
        color: Color(0xEEFFFFFF),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: PostHeader(index, post, toggleSearch),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Text(post.description)),
            post.images.length == 0
                ? Container()
                : Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: PostBodyImages(
                        companyName: post.shop.name, images: post.images)),
          ],
        ));
  }
}
