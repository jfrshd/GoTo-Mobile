import 'dart:convert';

import 'package:gotomobile/models/category.dart';
import 'package:gotomobile/models/filter.dart';
import 'package:meta/meta.dart';

@immutable
class FilterState {
  final List<Filter> sortTypes;

  final List<Filter> postTypes;

  final List<Category> categories;

  const FilterState({
    this.sortTypes = const [],
    this.postTypes = const [],
    this.categories = const [],
  });

  FilterState copyWith({sortTypes, postTypes, categories}) {
    return FilterState(
      sortTypes: sortTypes ?? this.sortTypes,
      postTypes: postTypes ?? this.postTypes,
      categories: categories ?? this.categories,
    );
  }

  dynamic toJson() => {
        'sortTypes': sortTypes.map((f) => f.selected ? 1 : 0).toList(),
        'postTypes': postTypes.map((f) => f.selected ? 1 : 0).toList(),
//        'categories': categories.map((f) => f.selected ? 1 : 0).toList(),
      };

  @override
  String toString() {
    return 'FilterState: ${JsonEncoder.withIndent('  ').convert(this)}';
  }
}
