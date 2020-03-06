import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:gotomobile/services/shareService.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../api.dart';

class ImageViewerPage extends StatefulWidget {
	final List<String> images;
  final String shopName;
  int selectedIndex;

  ImageViewerPage({this.images, this.shopName, this.selectedIndex});

  _ImageViewerPageState createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
			centerTitle: true,
			backgroundColor: Colors.black,
			title: Text(widget.shopName),
			actions: <Widget>[
				IconButton(
					icon: Icon(Icons.share),
					onPressed: () {
						// TODO: share image & link into app
						shareSingleImage(
							widget.shopName,
							"This is the caption Jaafar wrote!",
							API.serverAddress +
								"/" +
								widget.images[widget.selectedIndex]
									.replaceFirst("public/", ""));
					},
				)
			],
        ),
        body: Stack(
          children: <Widget>[
            PhotoViewGallery.builder(
              customSize: MediaQuery.of(context).size,
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
					imageProvider: NetworkImage(API.serverAddress +
						"/" +
						widget.images[index].replaceFirst("public/", "")),
					//initialScale: PhotoViewComputedScale.contained,
				);
              },
              pageController: PageController(initialPage: widget.selectedIndex),
              itemCount: widget.images.length,
              backgroundDecoration: BoxDecoration(color: Colors.black),
              loadingChild: Container(
                decoration: BoxDecoration(color: Colors.black),
              ),
              /*
          backgroundDecoration: widget.backgroundDecoration,
          pageController: widget.pageController,*/
              onPageChanged: (i) {
                setState(() {
                  widget.selectedIndex = i;
                });
              },
            ),
            Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: 20),
                child: DotsIndicator(
                  dotsCount: widget.images.length,
                  position: widget.selectedIndex.toDouble(),
                  decorator: DotsDecorator(
                    size: const Size.square(9.0),
                    activeSize: const Size(18.0, 9.0),
                    activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ))
          ],
        ));
  }
}
