import 'dart:convert';

import 'package:gotomobile/models/account.dart';
import 'package:gotomobile/redux/states/region_state.dart';
import 'package:gotomobile/redux/states/states.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
    final bool switchingSplashScreen;
  final Account account;
  final CategoryState categoryState;
  final RegionState regionState;
  final List<String> posts;
  final List<String> shops;

  const AppState({
    this.switchingSplashScreen = false,
    this.account = const Account(),
    this.categoryState = const CategoryState(),
    this.regionState = const RegionState(),
    this.posts = const [],
    this.shops = const [],
  });

    dynamic toJson() =>
        {
            'switchingSplashScreen': switchingSplashScreen,
            'account': account,
            'categoryState': categoryState,
            'regionState': regionState,
            'posts': posts,
            'shops': shops,
        };

    @override
    String toString() {
        return 'AppState';
        return 'AppState: ${JsonEncoder.withIndent('  ').convert(this)}';
    }
}
