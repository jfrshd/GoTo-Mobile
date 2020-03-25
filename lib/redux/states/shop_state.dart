import 'dart:convert';

import 'package:gotomobile/models/models.dart';
import 'package:meta/meta.dart';

@immutable
class ShopState {
  final bool loading,
      failLoad,
      errorLoad,
      togglingFollow,
      failToggleFollow,
      errorToggleFollow;
  final int selectedShopId;
  final Map<int, Shop> shops;

  const ShopState({
    this.loading = false,
    this.failLoad = false,
    this.errorLoad = false,
    this.togglingFollow = false,
    this.failToggleFollow = false,
    this.errorToggleFollow = false,
    this.selectedShopId = -1,
    this.shops = const {},
  });

  ShopState copyWith({
    loading,
    failLoad,
    errorLoad,
    togglingFollow,
    failToggleFollow,
    errorToggleFollow,
    selectedShopId,
    shops,
  }) {
    return ShopState(
      loading: loading ?? this.loading,
      failLoad: failLoad ?? this.failLoad,
      errorLoad: errorLoad ?? this.errorLoad,
      selectedShopId: selectedShopId ?? this.selectedShopId,
      togglingFollow: togglingFollow ?? this.togglingFollow,
      failToggleFollow: failToggleFollow ?? this.failToggleFollow,
      errorToggleFollow: errorToggleFollow ?? this.errorToggleFollow,
      shops: shops ?? this.shops,
    );
  }

  dynamic toJson() => {
        'loading': loading,
        'failLoad': failLoad,
        'errorLoad': errorLoad,
        "togglingFollow": togglingFollow,
        "failToggleFollow": failToggleFollow,
        "errorToggleFollow": errorToggleFollow,
        'selectedShopId': selectedShopId,
        'shops': shops.values.toList(),
      };

  @override
  String toString() {
    return 'ShopState: ${JsonEncoder.withIndent('  ').convert(this)}';
  }
}
