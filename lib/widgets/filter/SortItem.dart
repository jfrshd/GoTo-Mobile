import 'package:flutter/material.dart';
import 'package:gotomobile/models/filter.dart';

class SortItem extends StatelessWidget {
	final Filter sortType;

  SortItem(this.sortType);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        color:
            sortType.selected ? Theme.of(context).primaryColor : Colors.white,
      ),
      child: Text(
		  sortType.title,
		  style: TextStyle(
			  color:
			  sortType.selected ? Colors.white : Theme
				  .of(context)
				  .primaryColor,
		  ),
      ),
    );
  }
}
