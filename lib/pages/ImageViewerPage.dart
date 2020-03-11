import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:gotomobile/utils/GlobalMethods.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../api.dart';

class ImageViewerPage extends StatefulWidget {
  final List<String> images;
  final String shopName;
  final String postDescription;
  int selectedIndex;

  ImageViewerPage(
      this.images, this.shopName, this.postDescription, this.selectedIndex);

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
                GlobalMethods.shareSingleImage(
                    widget.shopName,
                    widget.postDescription,
                    API.serverAddress +
                        "/" +
                        widget.images[widget.selectedIndex]);
              },
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            PhotoViewGallery.builder(
              loadingBuilder: (context, progress) =>
                  Container(
                    color: Colors.black,
                    child: Center(
                      child: Container(
                          width: 40.0,
                          height: 40.0,
                          child: CircularProgressIndicator()),
                    ),
                  ),
              loadFailedChild: Container(
                color: Colors.black,
                child: Center(
                  child: Text(
                    'Failed to load image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              customSize: MediaQuery
                  .of(context)
                  .size,
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: CachedNetworkImageProvider(
                      API.serverAddress + "/" + widget.images[index]),
                  minScale: 1.0,
                  maxScale: 1.0,
                );
              },
              pageController: PageController(initialPage: widget.selectedIndex),
              itemCount: widget.images.length,
              backgroundDecoration: BoxDecoration(color: Colors.black),
              loadingChild: Container(
                decoration: BoxDecoration(color: Colors.black),
              ),
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
