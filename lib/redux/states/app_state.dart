import 'dart:convert';

import 'package:gotomobile/models/account.dart';
import 'package:gotomobile/redux/states/states.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final Account account;
  final CategoryState categoryState;
  final List<String> regions;
  final List<String> posts;
  final List<String> shops;

  const AppState({
    this.account = const Account(),
    this.categoryState = const CategoryState(),
    this.regions = const [],
    this.posts = const [],
    this.shops = const [],
  });

  dynamic toJson() => {
        'account': account,
        'categoryState': categoryState,
        'regions': regions,
        'posts': posts,
        'shops': shops,
      };

  @override
  String toString() {
    return 'AppState: ${JsonEncoder.withIndent('  ').convert(this)}';
  }
}
