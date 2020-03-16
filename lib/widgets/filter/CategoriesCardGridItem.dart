import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gotomobile/api.dart';
import 'package:gotomobile/models/category.dart';

class CategoriesCardGridItem extends StatelessWidget {
  final Category category;

  CategoriesCardGridItem(this.category);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color:
              category.selected ? Theme.of(context).primaryColor : Colors.white,
          border: Border.all(
            width: 1,
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 3,
            child: SizedBox.fromSize(
              size: Size(40, 40),
              child: SvgPicture.network(
                API.serverAddress + "/" + category.thumbnail,
                placeholderBuilder: (context) => CircularProgressIndicator(),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                category.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: category.selected
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
