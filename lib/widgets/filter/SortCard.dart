import 'package:flutter/material.dart';
import 'package:gotomobile/widgets/Filter/SortItem.dart';

class SortCard extends StatefulWidget {
  @override
  _SortCardState createState() => _SortCardState();
}

class _SortCardState extends State<SortCard> {
  List sortTypes = [
    {'title': 'Date Posted', 'selected': true},
    {'title': 'Sale Percentage', 'selected': false},
    {'title': 'Date Begin', 'selected': false},
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
              'Sort',
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
                  .toList())
        ]),
      ),
    );
  }

  onTap(int index) {
    print('onTap ' + index.toString());
    setState(() {
      sortTypes = sortTypes.map((e) => {...e, 'selected': false}).toList();
      sortTypes[index]['selected'] = true;
    });
  }
}
