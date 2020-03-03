import 'package:flutter/material.dart';
import 'package:gotomobile/models/shop.dart';

import '../../api.dart';

class CompanyDetailsHeader extends StatelessWidget {
  final Shop shop;
  final String heroTag;

  CompanyDetailsHeader({this.shop, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          children: <Widget>[
            SizedBox.fromSize(
                size: Size(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height * 0.2),
                child: Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.grey[100]))),
                  child: Hero(
                      tag: "company" + heroTag,
                      child: Image.network(
                          API.serverAddress +
                              "/" +
                              shop.coverPhoto.replaceFirst("public/", ""),
                          fit: BoxFit.fill)),
                )),
            Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.15, left: 10),
                decoration: new BoxDecoration(
                  color: Colors.grey[200], // border color
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(0.5),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                    API.serverAddress +
                        "/" +
                        shop.logo.replaceFirst("public/", ""),
                  ),
                )),
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Hero(
              tag: "companyName" + heroTag,
              createRectTween: createRectTween,
              child: new Material(
                color: Colors.transparent,
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

  RectTween createRectTween(Rect begin, Rect end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }
}
