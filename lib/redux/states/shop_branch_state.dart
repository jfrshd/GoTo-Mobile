import 'dart:convert';

import 'package:gotomobile/models/models.dart';
import 'package:meta/meta.dart';

@immutable
class ShopBranchState {
  final bool loading, failLoad, errorLoad;
  final Map<int, List<Branch>> shopBranches;

  const ShopBranchState({
    this.loading = false,
    this.failLoad = false,
    this.errorLoad = false,
    this.shopBranches = const {},
  });

  ShopBranchState copyWith({loading, failLoad, errorLoad, shopBranches}) {
    return ShopBranchState(
      loading: loading ?? this.loading,
      failLoad: failLoad ?? this.failLoad,
      errorLoad: errorLoad ?? this.errorLoad,
      shopBranches: shopBranches ?? this.shopBranches,
    );
  }

  dynamic toJson() => {
        'loading': loading,
        'failLoad': failLoad,
        'errorLoad': errorLoad,
        'shopBranches': shopBranches.values.toList(),
      };

  @override
  String toString() {
    return 'BranchState: ${JsonEncoder.withIndent('  ').convert(this)}';
  }
}
