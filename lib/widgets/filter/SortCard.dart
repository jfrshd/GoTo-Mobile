import 'package:flutter/material.dart';
import 'package:gotomobile/models/filter.dart';
import 'package:gotomobile/widgets/Filter/SortItem.dart';

class SortCard extends StatefulWidget {
  final List<Filter> sortTypes;
  final void Function(List<Filter>, int) saveSortTypes;

  SortCard(this.sortTypes, this.saveSortTypes);

  @override
  _SortCardState createState() => _SortCardState();
}

class _SortCardState extends State<SortCard> {
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
			  children: widget.sortTypes
				  .asMap()
				  .entries
				  .map((entry) =>
				  GestureDetector(
					  onTap: () => onTap(entry.key),
					  child: SortItem(entry.value)))
				  .toList())
        ]),
      ),
    );
  }

  onTap(int index) {
	  widget.saveSortTypes(widget.sortTypes, index);
  }
}
