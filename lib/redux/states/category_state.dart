import 'dart:convert';

import 'package:gotomobile/models/category.dart';
import 'package:meta/meta.dart';

@immutable
class CategoryState {
  final bool loading;
  final bool fail;
  final bool error;
  final List<Category> categories;

  const CategoryState({
    this.loading = false,
    this.fail = false,
    this.error = false,
    this.categories = const [],
  });

  CategoryState copyWith({loading, fail, error, categories}) {
    return CategoryState(
      loading: loading ?? this.loading,
      fail: fail ?? this.fail,
      error: error ?? this.error,
      categories: categories ?? this.categories,
    );
  }

  dynamic toJson() => {
        'loading': loading,
        'fail': fail,
        'error': error,
        'categories': categories,
      };

  @override
  String toString() {
    return 'CategoryState: ${JsonEncoder.withIndent('  ').convert(this)}';
  }
}
