import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share/share.dart';

import '../api.dart';

class ImageViewerPage extends StatefulWidget {
  final List<String> images;
  final String companyName;
  int selectedIndex;

  ImageViewerPage({this.images, this.companyName, this.selectedIndex});

  _ImageViewerPageState createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(widget.companyName),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share(widget.images[widget.selectedIndex]);
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
                  imageProvider:
                  NetworkImage(
                      API.serverAddress +
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
