import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gotomobile/models/shop.dart';

import '../api.dart';

class ShopItem extends StatelessWidget {
  int index;
  Shop shop;

  ShopItem(this.index, this.shop);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
      color: Color(0xEEFFFFFF),
      child: Center(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          dense: true,
          leading: Hero(
              tag: "shop" + index.toString() + shop.id.toString(),
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
                      API.serverAddress + "/" + shop.logo,
                    ),
                  ))),
          title: Text(shop.name),
        ),
      ),
    );
  }
}
