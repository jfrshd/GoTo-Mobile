import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';

Future<void> shareSingleImage(name, text, imageUrl) async {
  var request = await HttpClient().getUrl(Uri.parse(
      'https://shop.esys.eu/media/image/6f/8f/af/amlog_transport-berwachung.jpg'));
  var response = await request.close();
  Uint8List bytes = await consolidateHttpClientResponseBytes(response);
  await Share.file('Share Image',
      name + '_' + DateTime.now().toString() + '.jpg', bytes, 'image/jpg',
      text: text);
}
