import 'dart:convert';

import 'package:gotomobile/models/post.dart';
import 'package:meta/meta.dart';

@immutable
class ShopPostState {
  final bool loading, failLoad, errorLoad, moreToLoad, errorLoadingMore;
  final Map<int, int> currentPages;
  final Map<int, List<Post>> shopPosts;

  const ShopPostState({
    this.loading = false,
    this.failLoad = false,
    this.errorLoad = false,
    this.moreToLoad = true,
    this.errorLoadingMore = false,
    this.currentPages = const {},
    this.shopPosts = const {},
  });

  ShopPostState copyWith({
    loading,
    failLoad,
    errorLoad,
    moreToLoad,
    errorLoadingMore,
    currentPages,
    shopPosts,
  }) {
    return ShopPostState(
      loading: loading ?? this.loading,
      failLoad: failLoad ?? this.failLoad,
      errorLoad: errorLoad ?? this.errorLoad,
      moreToLoad: moreToLoad ?? this.moreToLoad,
      errorLoadingMore: errorLoadingMore ?? this.errorLoadingMore,
      currentPages: currentPages ?? this.currentPages,
      shopPosts: shopPosts ?? this.shopPosts,
    );
  }

  dynamic toJson() => {
        'loading': loading,
        'failLoad': failLoad,
        'errorLoad': errorLoad,
        'moreToLoad': moreToLoad,
        'errorLoadingMore': errorLoadingMore,
        'currentPages': currentPages,
        'shopPosts': shopPosts,
      };

  @override
  String toString() {
    return 'ShopPostState: ${JsonEncoder.withIndent('  ').convert(this)}';
  }
}
