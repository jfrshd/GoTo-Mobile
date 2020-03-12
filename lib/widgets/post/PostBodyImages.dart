import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gotomobile/pages/ImageViewerPage.dart';

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
            child: CachedNetworkImage(
              imageUrl: API.serverAddress + "/" + images[0],
              placeholder: (context, url) =>
                  SizedBox.fromSize(
                      size: Size(
                          MediaQuery
                              .of(context)
                              .size
                              .width,
                          MediaQuery
                              .of(context)
                              .size
                              .width,
                      ),
                      child: Container(
                          color: Colors.grey[100],
                          child: Center(child: CircularProgressIndicator()),
                      ),
                  ),
              errorWidget: (context, url, error) =>
                  SizedBox.fromSize(
                      size: Size(
                          MediaQuery
                              .of(context)
                              .size
                              .width,
                          MediaQuery
                              .of(context)
                              .size
                              .width,
                      ),
                      child: Container(
                          color: Colors.grey[100],
                          child: Center(
                              child: Icon(Icons.broken_image),
                          ),
                      ),
                  ),
              fit: BoxFit.fill,
            ),
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
          size: Size(MediaQuery
              .of(context)
              .size
              .width,
              MediaQuery
                  .of(context)
                  .size
                  .height * 0.2),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (BuildContext context, int index) {
                  return Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.3,
                      child: InkWell(
                          child: CachedNetworkImage(
                              imageUrl: API.serverAddress + "/" + images[index],
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.fill),
                          onTap: () {
//                          toggleSearch();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ImageViewerPage(
                                              images, shopName, postDescription,
                                              index)),
                              );
                          },
                      ));
              }),
      );
  }
}
