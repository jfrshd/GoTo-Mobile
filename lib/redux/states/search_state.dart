import 'dart:convert';

import 'package:gotomobile/models/shop.dart';
import 'package:meta/meta.dart';

@immutable
class SearchState {
  final bool loading, failLoad, errorLoad;
  final String searchTerm;
  final List<Shop> shops;

  const SearchState({
    this.loading = false,
    this.failLoad = false,
    this.errorLoad = false,
    this.searchTerm = 'GoTo',
    this.shops = const [],
  });

  SearchState copyWith({searchTerm, loading, failLoad, errorLoad, shops}) {
    return SearchState(
      loading: loading ?? this.loading,
      failLoad: failLoad ?? this.failLoad,
      errorLoad: errorLoad ?? this.errorLoad,
      searchTerm: searchTerm ?? this.searchTerm,
      shops: shops ?? this.shops,
    );
  }

  dynamic toJson() =>
	  {
		  'loading': loading,
		  'failLoad': failLoad,
		  'errorLoad': errorLoad,
		  'searchTerm': searchTerm,
		  'shops': shops.length,
	  };

  @override
  String toString() {
    return 'SearchState: ${JsonEncoder.withIndent('  ').convert(this)}';
  }
}
