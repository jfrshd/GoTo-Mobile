import 'package:flutter/material.dart';
import 'package:gotomobile/pages/ImageViewerPage.dart';
import 'package:gotomobile/widgets/image/CacheImage.dart';

import '../../api.dart';

class PostBodyImages extends StatelessWidget {
  final String shopName;
  final String postDescription;
  final List<String> images;

  PostBodyImages(this.shopName, this.postDescription, this.images);

  @override
  Widget build(BuildContext context) {
    return images.length == 1
        ? InkWell(
		child: CacheImage(API.serverAddress + "/" + images[0]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ImageViewerPage(images, shopName, postDescription, 0)),
              );
            },
          )
        : SizedBox.fromSize(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.width),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: InkWell(
                        child:
                            CacheImage(API.serverAddress + "/" + images[index]),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageViewerPage(
                                    images, shopName, postDescription, index)),
                          );
                        },
                      ));
                }),
          );
  }
}
