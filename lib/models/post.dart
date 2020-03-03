import 'package:gotomobile/models/shop.dart';

import 'branch.dart';

class Post {
  int id, shopId;
  Shop shop;
  String description;
  int views;
  DateTime datePosted, dateStart, dateEnd;
  List<String> images;
  List<Branch> targetBranches;

  Post(
      {this.id,
      this.shopId,
      this.shop,
      this.description,
      this.views,
      this.datePosted,
      this.dateStart,
      this.dateEnd,
      this.images,
      this.targetBranches});

  factory Post.fromJson(Map<String, dynamic> _json) {
    return Post(
      id: _json['id'] as int,
      shopId: _json['shop_id'] as int,
      shop: !_json.containsKey('shop') ? null : Shop.fromJson(_json['shop']),
      description: _json['description'] as String,
      views: _json['views'] as int,
      datePosted: DateTime.parse(_json['date_accepted']),
      dateStart: DateTime.parse(_json['date_start']),
      dateEnd: DateTime.parse(_json['date_end']),
      images: !_json.containsKey('images')
          ? <String>[]
          : List<String>.from(_json['images']),
      targetBranches: !_json.containsKey('branches')
          ? <Branch>[]
          : List.from(_json['branches'])
              .map<Branch>((branch) => Branch.fromJson(branch))
              .toList(),
    );
  }
}
