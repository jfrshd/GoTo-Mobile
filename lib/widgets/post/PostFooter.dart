import 'package:flutter/material.dart';
import 'package:gotomobile/utils/GlobalMethods.dart';

class PostFooter extends StatelessWidget {
  DateTime dateStart, dateEnd;

  PostFooter(this.dateStart, this.dateEnd);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(GlobalMethods.formatDate(dateStart)),
          Icon(
            Icons.arrow_right,
            size: 20,
          ),
          Text(GlobalMethods.formatDate(dateEnd)),
        ],
      ),
    );
  }
}
