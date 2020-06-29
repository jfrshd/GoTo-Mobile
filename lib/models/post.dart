import 'dart:convert';

import 'package:gotomobile/models/shop.dart';

import 'branch.dart';

enum PostType { Sale, NewCollection, Flier }

class Post {
  int id, shopId;
  Shop shop;
  String description;
  int views;
  PostType postType;
  DateTime datePosted, dateStart, dateEnd;
  List<String> images;
  List<Branch> targetBranches;

  Post({
    this.id,
    this.shopId,
    this.shop,
    this.description,
    this.views,
    this.postType,
    this.datePosted,
    this.dateStart,
    this.dateEnd,
    this.images,
    this.targetBranches,
  });

  factory Post.fromJson(Map<String, dynamic> _json) {
    PostType postType;
    switch (_json['post_type'] as int) {
      case 0:
        postType = PostType.Sale;
        break;
      case 1:
        postType = PostType.NewCollection;
        break;
      case 2:
        postType = PostType.Flier;
        break;
    }

    return Post(
      id: _json['id'] as int,
      shopId: _json['shop_id'] as int,
      shop: _json.containsKey('shop') ? Shop.fromJson(_json['shop']) : null,
      description: _json['description'] as String,
      views: _json['views'] as int,
      postType: postType,
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

  dynamic toJson() => {
        'id': id,
        'shopId': shopId,
        'shop': shop,
        'description': description,
        'views': views,
        'datePosted': datePosted.toString(),
        'dateStart': dateStart.toString(),
        'dateEnd': dateEnd.toIso8601String(),
      };

  @override
  String toString() {
    return JsonEncoder.withIndent('  ').convert(this);
  }
}
