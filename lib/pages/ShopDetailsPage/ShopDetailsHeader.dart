import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:gotomobile/models/shop.dart';
import 'package:gotomobile/widgets/image/CacheImage.dart';

import '../../api.dart';

class ShopDetailsHeader extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  final Shop shop;
  final String heroTag;
  final Function(int) toggleFollow;

  ShopDetailsHeader(
      this.shop, this.heroTag, this.scaffoldKey, this.toggleFollow);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          children: <Widget>[
            SizedBox.fromSize(
                size: Size(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height * 0.25),
                child: Container(
					decoration: BoxDecoration(
						border: Border(
							bottom: BorderSide(
								color: Colors.grey[100],
							),
						),
					),
					child: Hero(
						tag: "shop" + heroTag,
						child:
						CacheImage(API.serverAddress + "/" + shop.coverPhoto),
					),
                )),
            Container(
              margin: EdgeInsets.all(5),
              child: IconButton(
                icon: Icon(
                  Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.2,
                  left: 10,
                  right: 10),
              child: Row(
                children: <Widget>[
					Container(
						decoration: new BoxDecoration(
							color: Colors.grey[200],
							// border color
							shape: BoxShape.circle,
						),
						padding: EdgeInsets.all(0.5),
						// TODO: replace Circle Avatar ?
						child: CircleAvatar(
							radius: 50,
							backgroundColor: Colors.white,
							backgroundImage: AdvancedNetworkImage(
								API.serverAddress + "/" + shop.logo,
								useDiskCache: true,
								cacheRule: CacheRule(
									maxAge: const Duration(days: 7)),
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
					Expanded(
						child: Container(),
					),
					Container(
						margin: EdgeInsets.only(top: 20),
						child: GestureDetector(
							child: shop.followed
								? Row(
								children: <Widget>[
									Padding(
                                  padding: const EdgeInsets.only(right: 3),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.grey[500],
                                    size: 20,
                                  ),
                                ),
                                Text(
                                  "Following",
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                              ],
                            )
                          : Text(
                              "Follow",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                      onTap: () {
						  toggleFollow(shop.id);
                      },
                    ),
                  ),
//                  Column(
//                    children: <Widget>[
//                      Text(shop.nbOfFollowers.toString()),
//                      Text(shop.nbOfRatings.toString()),
//                      Text(shop.accountRating.toString()),
//                      Text(shop.avgRating.toString()),
//                    ],
//                  )
                ],
              ),
            ),
          ],
        ),
        Container(
			margin: EdgeInsets.only(left: 10),
			child: Hero(
				tag: "shopName" + heroTag,
				createRectTween: createRectTween,
				child: Container(
					margin: EdgeInsets.only(top: 10),
					child: Text(
						shop.name,
						style: TextStyle(
							fontSize: 25,
							fontFamily: "Roboto",
							color: Colors.black,
							decoration: TextDecoration.none,
							fontWeight: FontWeight.normal),
					),
				),
			),
        )
      ],
    );
  }

  RectTween createRectTween(Rect begin, Rect end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }
}
