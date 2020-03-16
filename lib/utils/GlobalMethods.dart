import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class GlobalMethods {
  static call(String phoneNumber) async {
    final url = 'tel:' + phoneNumber;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  static Future<void> shareSingleImage(name, text, imageUrl) async {
    var request = await HttpClient().getUrl(Uri.parse(imageUrl));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    await Share.file('Share Image',
        name + '_' + DateTime.now().toString() + '.jpg', bytes, 'image/jpg',
        text: text);
  }

  static showSnackBar(String e, GlobalKey<ScaffoldState> _scaffoldKey) {
    final snackBar = SnackBar(
      content: Text(e),
      duration: Duration(seconds: 2),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  static String formatDate(DateTime date) {
    print(DateTime.now().difference(date).inDays);
    final diffDays = DateTime.now().difference(date).inDays;
    final diffHours = DateTime.now().difference(date).inHours;
    final diffMinutes = DateTime.now().difference(date).inMinutes;
    final diffSeconds = DateTime.now().difference(date).inSeconds;
    if (diffDays == 0) {
      if (diffHours == 0) {
        if (diffMinutes == 0) {
          if (diffSeconds == 1) {
            return diffSeconds.toString() + " second ago";
          } else {
            return diffSeconds.toString() + " seconds ago";
          }
        } else if (diffMinutes == 1) {
          return diffMinutes.toString() + " minute ago";
        } else {
          return diffMinutes.toString() + " minutes ago";
        }
      } else if (diffHours == 1) {
        return diffHours.toString() + " hour ago";
      } else {
        return diffHours.toString() + " hours ago";
      }
    } else if (diffDays == 1) {
      return "Yesterday at " + DateFormat('jm').format(date);
    } else if (diffDays < 365) {
      return DateFormat('MMMd').format(date) +
          " at " +
          DateFormat('jm').format(date);
    } else {
      return DateFormat('yMMMd').format(date) +
          " at " +
          DateFormat('jm').format(date);
    }
  }
}
