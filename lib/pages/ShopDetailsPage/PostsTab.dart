import 'package:flutter/material.dart';
import 'package:gotomobile/models/shop.dart';
import 'package:gotomobile/widgets/PostsList.dart';

class PostsTab extends StatelessWidget {
  final Shop shop;

  PostsTab(this.shop);

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.grey[100], child: new PostsList(shop: shop));
  }
}
