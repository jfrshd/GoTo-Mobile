import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gotomobile/models/shop.dart';
import 'package:gotomobile/services/shopsService.dart';

import '../../api.dart';

class ShopDetailsHeader extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  final Shop shop;
  final String heroTag;

  ShopDetailsHeader(this.shop, this.heroTag, this.scaffoldKey);

  @override
  _ShopDetailsHeaderState createState() => _ShopDetailsHeaderState(shop);
}

class _ShopDetailsHeaderState extends State<ShopDetailsHeader> {
  Shop shop;

  _ShopDetailsHeaderState(this.shop);

  @override
  void initState() {
    super.initState();
    loadData();
  }

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
                      border:
                          Border(bottom: BorderSide(color: Colors.grey[100]))),
                  child: Hero(
                      tag: "shop" + widget.heroTag,
                      child: CachedNetworkImage(
                          imageUrl: API.serverAddress + "/" + shop.coverPhoto,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.fill)),
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
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: CachedNetworkImageProvider(
                            API.serverAddress + "/" + shop.logo),
                      )),
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
                        toggleFollowShop(shop.id, shop.followed)
                            .then((response) {
                          final parsed = Map<String, dynamic>.from(
                              json.decode(response.body));
                          if (parsed["status"] == "success")
                            setState(() {
                              shop.followed = !shop.followed;
                            });
                        }).catchError((error) {
                          print("toggleFollowShop() error: ");
                          print(error);
                          // handle error
                        });
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
              tag: "shopName" + widget.heroTag,
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
              )),
        )
      ],
    );
  }

  loadData() {
    getShop(shop.id).then((response) {
      final parsed = Map<String, dynamic>.from(json.decode(response.body));
      if (parsed["status"] == "success") {
        final _shop = Shop.fromJson(parsed['shop']);
        setState(() {
          shop = _shop;
        });
      } else if (parsed["status"] == "fail") {
        // TODO: handle fail
//        setState(() {
//          _error = true;
//          _loadingCategories = false;
//        });
      } else if (parsed["status"] == "error") {
        // TODO: handle error

//        setState(() {
//          _error = true;
//          _loadingCategories = false;
//        });
      }
    }).catchError((e) {
      print("getShop error: ");
      print(e);
      // TODO: handle error
//      setState(() {
//        _error = true;
//        _loadingCategories = false;
//      });
    });
  }

  RectTween createRectTween(Rect begin, Rect end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }
}
