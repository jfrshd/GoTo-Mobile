import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:gotomobile/models/models.dart';
import 'package:gotomobile/models/post.dart';
import 'package:gotomobile/utils/GlobalMethods.dart';

import '../../api.dart';

class PostHeader extends StatelessWidget {
  final int index;
  final Post post;
  final void Function(int, Shop, BuildContext) selectShop;

  PostHeader(this.index, this.post, this.selectShop);

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
            backgroundImage: AdvancedNetworkImage(
              API.serverAddress + "/" + post.shop.logo,
              useDiskCache: true,
              cacheRule: CacheRule(maxAge: const Duration(days: 7)),
              loadedCallback: () {
                // TODO: handle
                print('It works!');
              },
              loadFailedCallback: () {
                // TODO: handle
                print('Oh, no!');
              },
              loadingProgress: (double progress, _) {
                // TODO: handle
                print('Now Loading: $progress');
              },
            ),
          ),
        ),
      ),
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
		  if (selectShop != null) selectShop(index, post.shop, context);
      },
    );
  }
}
