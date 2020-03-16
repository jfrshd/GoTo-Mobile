import 'package:flutter/material.dart';
import 'package:gotomobile/widgets/Filter/SortItem.dart';

class PostTypeCard extends StatefulWidget {
  @override
  _PostTypeCardState createState() => _PostTypeCardState();
}

class _PostTypeCardState extends State<PostTypeCard> {
  List sortTypes = [
    {'title': 'Sale', 'selected': true},
    {'title': 'New Collection', 'selected': true},
    {'title': 'Flyer', 'selected': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Center(
        child: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              'Post Types',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: sortTypes
                .asMap()
                .entries
                .map((entry) => GestureDetector(
                    onTap: () => onTap(entry.key),
                    child: SortItem(entry.value)))
                .toList(),
          )
        ]),
      ),
    );
  }

  onTap(int index) {
    setState(() {
      sortTypes[index]['selected'] = !sortTypes[index]['selected'];
    });
  }
}
