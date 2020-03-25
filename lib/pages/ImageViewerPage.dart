import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:gotomobile/utils/GlobalMethods.dart';
import 'package:gotomobile/widgets/image/CacheImage.dart';

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
        backgroundColor: Colors.black,
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
                  API.serverAddress + "/" + widget.images[widget.selectedIndex],
                );
              },
            )
          ],
        ),
        body: Stack(
			children: <Widget>[
				Center(
					child: CarouselSlider.builder(
						aspectRatio: 1,
						scrollPhysics: const BouncingScrollPhysics(),
						enableInfiniteScroll: false,
						viewportFraction: 1.0,
						initialPage: widget.selectedIndex,
						itemCount: widget.images.length,
						itemBuilder: (BuildContext context, int index) =>
							CacheImage(
								API.serverAddress + "/" + widget.images[index],
								retryColor: Colors.grey[300],
								backgroundColor: Colors.black,
							),
						onPageChanged: (index) {
							setState(() {
								widget.selectedIndex = index;
							});
						},
					),
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
