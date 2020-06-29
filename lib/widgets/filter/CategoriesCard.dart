import 'package:flutter/material.dart';
import 'package:gotomobile/models/category.dart';
import 'package:gotomobile/widgets/Filter/CategoriesCardGridItem.dart';

class CategoriesCard extends StatefulWidget {
  final List categories;
  final void Function(List<Category>, int) saveFilterCategories;

  CategoriesCard(this.categories, this.saveFilterCategories);

  @override
  _CategoriesCardState createState() => _CategoriesCardState();
}

class _CategoriesCardState extends State<CategoriesCard> {
  @override
  Widget build(BuildContext context) {
	  final orientation = MediaQuery
		  .of(context)
		  .orientation;

	  return Container(
		  margin: const EdgeInsets.only(top: 5),
		  padding: const EdgeInsets.all(10),
		  color: Colors.white,
		  child: Center(
			  child: Column(children: <Widget>[
				  Container(
					  margin: EdgeInsets.only(bottom: 10),
					  child: Text(
						  'Categories',
						  style: TextStyle(fontSize: 20),
					  ),
				  ),
				  Container(
					  width: MediaQuery
						  .of(context)
						  .size
						  .width,
					  child: GridView.builder(
						  shrinkWrap: true,
						  physics: ScrollPhysics(),
						  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
							  crossAxisCount:
							  (orientation == Orientation.portrait) ? 3 : 4),
						  itemCount: widget.categories.length,
						  itemBuilder: (BuildContext context, int index) {
							  return GestureDetector(
								  onTap: () => onTap(index),
								  child: CategoriesCardGridItem(
									  widget.categories[index]));
						  },
					  ),
				  ),
			  ]),
		  ),
	  );
  }

  onTap(int index) {
	  widget.saveFilterCategories(widget.categories, index);
  }
}
