import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class CacheImage extends StatelessWidget {
  final String url;
  final Color retryColor, backgroundColor;

  CacheImage(
    this.url, {
    this.retryColor = const Color(0xFFBDBDBD),
    this.backgroundColor = const Color(0xFFFAFAFA),
  });

  @override
  Widget build(BuildContext context) {
    return TransitionToImage(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      image: AdvancedNetworkImage(
        url,
        useDiskCache: true,
        cacheRule: CacheRule(maxAge: const Duration(days: 7)),
        loadedCallback: () {
          //print('It works!');
        },
        loadFailedCallback: () {
			//print('Oh, no!');
        },
        loadingProgress: (double progress, _) {
			//print('Now Loading: $progress');
        },
      ),
      fit: BoxFit.fill,
      loadingWidgetBuilder: (_, double progress, __) => Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          color: backgroundColor,
          child: Center(
              child: CircularProgressIndicator(
            value: progress,
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            backgroundColor: Colors.grey[300],
          ))),
      enableRefresh: true,
      placeholder: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        color: backgroundColor,
        child: Center(
          child: Icon(
            Icons.refresh,
            color: retryColor,
          ),
        ),
      ),
    );
  }
}
