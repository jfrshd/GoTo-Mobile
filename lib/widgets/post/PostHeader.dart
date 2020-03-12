import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gotomobile/models/post.dart';
import 'package:gotomobile/pages/ShopDetailsPage/ShopDetailsPage.dart';
import 'package:gotomobile/utils/GlobalMethods.dart';

import '../../api.dart';

class PostHeader extends StatelessWidget {
  final int index;
  final Post post;
  final bool isHeaderClickable;

  PostHeader(this.index, this.post, this.isHeaderClickable);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 16),
      dense: true,
      leading: Hero(
          tag: "shop" +
              index.toString() +
              post.shopId.toString() +
              post.id.toString(),
          child: Container(
              decoration: new BoxDecoration(
                color: Colors.grey, // border color
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(0.5),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                backgroundImage: CachedNetworkImageProvider(
                    API.serverAddress + "/" + post.shop.logo,
                    errorListener: () {
                  print("error header");
                }),
              ))),
      title: Hero(
//          createRectTween: shopDetailsPage.createRectTween,
          tag: "shopName" +
              index.toString() +
              post.shopId.toString() +
              post.id.toString(),
          child: new Material(
            color: Colors.transparent,
            child: Text(
              post.shop.name,
              style: TextStyle(
                  fontSize: 20,
                  letterSpacing: .5,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal),
            ),
          )),
      subtitle: Hero(
          tag: "shopCategory" +
              index.toString() +
              post.shopId.toString() +
              post.id.toString(),
//          createRectTween: shopDetailsPage.createRectTween,
          child: Material(
              color: Colors.transparent,
              child: Text(
                GlobalMethods.formatDate(post.datePosted),
                style: TextStyle(
                    fontSize: 12,
                    letterSpacing: .5,
                    color: Colors.grey[500],
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal),
              ))),
      trailing: PopupMenuButton<int>(
        icon: Icon(Icons.more_vert),
        onSelected: (int index) {
          //TODO: add on click functionality
        },
        itemBuilder: (context) => [
          PopupMenuItem(
              value: 1,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(
                      Icons.bookmark,
                    ),
                    Text("Save")
                  ])),
          PopupMenuItem(
              value: 2,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(
                      Icons.share,
                    ),
                    Text("Share")
                  ])),
        ],
//
      ),
      onTap: () {
        if (isHeaderClickable)
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ShopDetailsPage(
                        heroTag: index.toString(),
                        shop: post.shop,
                      )));
      },
    );
  }
}
