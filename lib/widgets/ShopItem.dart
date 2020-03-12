import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gotomobile/models/shop.dart';
import 'package:gotomobile/pages/ShopDetailsPage/ShopDetailsPage.dart';

import '../api.dart';

class ShopItem extends StatelessWidget {
  int index;
  Shop shop;

  ShopItem(this.index, this.shop);

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
							backgroundImage: CachedNetworkImageProvider(
								API.serverAddress + "/" + shop.logo,
							),
						))),
				title: Text(shop.name),
				subtitle: Text(
					shop.nbOfBranches.toString() +
						" branch" +
						(shop.nbOfBranches == 1 ? "" : "es"),
				),
				onTap: () {
					Navigator.push(
						context,
						MaterialPageRoute(
							builder: (BuildContext context) =>
								ShopDetailsPage(
									heroTag: index.toString(), shop: shop),
						),
					);
				},
        ),
      ),
    );
  }
}
