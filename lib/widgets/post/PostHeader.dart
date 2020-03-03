import 'package:flutter/material.dart';
import 'package:gotomobile/models/post.dart';
import 'package:gotomobile/pages/CompanyDetailsPage/CompanyDetailsPage.dart';

import '../../api.dart';

class PostHeader extends StatelessWidget {
  final int index;
  final Post post;
  final Function toggleSearch;

  PostHeader(this.index, this.post, this.toggleSearch);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 16),
      dense: true,
      leading: Hero(
          tag: "company" + index.toString(),
          child: Container(
              decoration: new BoxDecoration(
                color: Colors.grey, // border color
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(0.5),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(API.serverAddress +
                    "/" +
                    post.shop.logo.replaceFirst("public/", "")),
              ))),
      title: Hero(
//          createRectTween: CompanyDetailsPage.createRectTween,
          tag: "companyName" + index.toString(),
          child: new Material(
            color: Colors.transparent,
            child: Text(
              post.shop.name,
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Roboto",
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal),
            ),
          )),
      subtitle: Hero(
          tag: "companyCategory" + post.shopId.toString(),
//          createRectTween: CompanyDetailsPage.createRectTween,
          child: Material(
              color: Colors.transparent,
              child: Text(
                post.shopId.toString(),
//                style: TextStyle(
//                    fontSize: 12,
//                    fontFamily: "Roboto",
//                    color: Colors.grey,
//                    decoration: TextDecoration.none,
//                    fontWeight: FontWeight.normal),
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => CompanyDetailsPage(
                      heroTag: index.toString(),
                      shop: post.shop,
                    )));
//        toggleSearch();
      },
    );
  }
}
