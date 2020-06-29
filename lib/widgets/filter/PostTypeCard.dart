import 'package:flutter/material.dart';
import 'package:gotomobile/models/filter.dart';
import 'package:gotomobile/widgets/Filter/SortItem.dart';

class PostTypeCard extends StatefulWidget {
  final List<Filter> postTypes;
  final void Function(List<Filter>, int) savePostTypes;

  PostTypeCard(this.postTypes, this.savePostTypes);

  @override
  _PostTypeCardState createState() => _PostTypeCardState();
}

class _PostTypeCardState extends State<PostTypeCard> {
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
			  children: widget.postTypes
				  .asMap()
				  .entries
				  .map((entry) =>
				  GestureDetector(
					  onTap: () => onTap(entry.key),
					  child: SortItem(entry.value)))
				  .toList(),
          )
        ]),
      ),
    );
  }

  onTap(int index) {
	  widget.savePostTypes(widget.postTypes, index);
  }
}
