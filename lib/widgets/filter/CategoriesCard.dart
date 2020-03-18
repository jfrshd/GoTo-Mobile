import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gotomobile/models/category.dart';
import 'package:gotomobile/services/categories_service.dart';
import 'package:gotomobile/widgets/Filter/CategoriesCardGridItem.dart';

class CategoriesCard extends StatefulWidget {
  @override
  _CategoriesCardState createState() => _CategoriesCardState();
}

class _CategoriesCardState extends State<CategoriesCard> {
  List<Category> _categories = List<Category>();

  void initState() {
    super.initState();
    if (_categories.length == 0) loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

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
            width: MediaQuery.of(context).size.width,
            child: GridView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      (orientation == Orientation.portrait) ? 3 : 4),
              itemCount: _categories.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () => onTap(index),
                    child: CategoriesCardGridItem(_categories[index]));
              },
            ),
          ),
        ]),
      ),
    );
  }

  onTap(int index) {
    setState(() {
      _categories[index].selected = !_categories[index].selected;
    });
  }

  void loadCategories() {
//    setState(() {
//      _loadingCategories = true;
//      _error = false;
//    });
    CategoriesService.fetchCategories('').then((response) {
      final parsed = Map<String, dynamic>.from(json.decode(response.body));
      if (parsed["status"] == "success") {
        final categories = parsed['categories']
            .map<Category>((json) => Category.fromJson(json))
            .toList();
        setState(() {
//          _error = false;
//          _loadingCategories = false;
          _categories = categories;
        });
      } else if (parsed["status"] == "fail") {
//        setState(() {
//          _error = true;
//          _loadingCategories = false;
//        });
      } else if (parsed["status"] == "error") {
//        setState(() {
//          _error = true;
//          _loadingCategories = false;
//        });
      }
    }).catchError((e) {
      print("getCategories error: ");
      print(e);
//      setState(() {
//        _error = true;
//        _loadingCategories = false;
//      });
    });
  }
}
