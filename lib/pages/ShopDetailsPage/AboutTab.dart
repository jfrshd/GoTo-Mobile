import 'package:flutter/material.dart';

class AboutTab extends StatelessWidget {
  String about;

  AboutTab(this.about);

  @override
  Widget build(BuildContext context) {
//    return SizedBox(        height: 300, child: Text(MediaQuery.of(context).size.height.toString()));
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.all(25),
      child: Text(about),
    );
  }
}
