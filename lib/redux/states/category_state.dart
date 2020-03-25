import 'dart:convert';

import 'package:gotomobile/models/category.dart';
import 'package:meta/meta.dart';

@immutable
class CategoryState {
  final bool loading, failLoad, errorLoad;
  final bool updating, failUpdate, errorUpdate;
  final List<Category> categories;

  const CategoryState({
    this.loading = false,
    this.failLoad = false,
    this.errorLoad = false,
    this.updating = false,
    this.failUpdate = false,
    this.errorUpdate = false,
    this.categories = const [],
  });

  CategoryState copyWith(
      {loading,
      failLoad,
      errorLoad,
      updating,
      failUpdate,
      errorUpdate,
      categories}) {
    return CategoryState(
      loading: loading ?? this.loading,
      failLoad: failLoad ?? this.failLoad,
      errorLoad: errorLoad ?? this.errorLoad,
      updating: updating ?? this.updating,
      failUpdate: failUpdate ?? this.failUpdate,
      errorUpdate: errorUpdate ?? this.errorUpdate,
      categories: categories ?? this.categories,
    );
  }

  dynamic toJson() => {
        'loading': loading,
        'failLoad': failLoad,
        'errorLoad': errorLoad,
        'updating': updating,
        'failUpdate': failUpdate,
        'errorUpdate': errorUpdate,
        'categories': categories,
      };

  @override
  String toString() {
    return 'CategoryState: ${JsonEncoder.withIndent('  ').convert(this)}';
  }
}
