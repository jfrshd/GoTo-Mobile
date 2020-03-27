import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:gotomobile/models/shop.dart';

import '../api.dart';

class ShopItem extends StatelessWidget {
  final int index;
  final Shop shop;
  final void Function(int, Shop, BuildContext) selectShop;

  ShopItem(this.index, this.shop, this.selectShop);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
      color: Color(0xEEFFFFFF),
      child: Center(
        child: ListTile(
//          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          leading: Hero(
            tag: "shop" + index.toString() + shop.id.toString(),
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.grey, // border color
                shape: BoxShape.circle,
              ),
//                  padding: EdgeInsets.all(0.5),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                backgroundImage: AdvancedNetworkImage(
                  API.serverAddress + "/" + shop.logo,
                  useDiskCache: true,
                  cacheRule: CacheRule(maxAge: const Duration(days: 7)),
                  loadedCallback: () {
                    // TODO: handle
                    //print('It works!');
                  },
                  loadFailedCallback: () {
                    // TODO: handle
                    //print('Oh, no!');
                  },
                  loadingProgress: (double progress, _) {
                    // TODO: handle
                    //print('Now Loading: $progress');
                  },
                ),
              ),
            ),
          ),
          title: Text(shop.name),
          subtitle: Text(
            shop.nbOfBranches.toString() +
                " branch" +
                (shop.nbOfBranches == 1 ? "" : "es"),
          ),
          onTap: () {
            selectShop(index, shop, context);
          },
        ),
      ),
    );
  }
}
