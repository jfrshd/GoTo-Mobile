import 'package:flutter/material.dart';
import 'package:gotomobile/pages/ImageViewerPage.dart';

import '../../api.dart';

class PostBodyImages extends StatelessWidget {
  final String shopName;
  final List<String> images;

  PostBodyImages({this.shopName, this.images});

  @override
  Widget build(BuildContext context) {
    return images.length == 1
        ? InkWell(
            child: Image.network(
                API.serverAddress + "/" + images[0].replaceFirst("public/", ""),
                fit: BoxFit.fill),
            onTap: () {
//                          toggleSearch();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ImageViewerPage(
						shopName: shopName,
						images: images,
						selectedIndex: 0,
                        )),
              );
            },
          )
        : SizedBox.fromSize(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height * 0.2),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: InkWell(
                        child: Image.network(
                            API.serverAddress +
                                "/" +
                                images[index].replaceFirst("public/", ""),
                            fit: BoxFit.fill),
                        onTap: () {
//                          toggleSearch();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageViewerPage(
									shopName: shopName,
									images: images,
									selectedIndex: index,
                                    )),
                          );
                        },
                      ));
                }),
          );
  }
}
