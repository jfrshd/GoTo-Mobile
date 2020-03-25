import 'dart:convert';

import 'package:gotomobile/models/post.dart';
import 'package:meta/meta.dart';

@immutable
class PostState {
  final bool loading, failLoad, errorLoad, moreToLoad, errorLoadingMore;
  final int currentPage;
  final List<Post> posts;

  const PostState({
    this.loading = false,
    this.failLoad = false,
    this.errorLoad = false,
    this.moreToLoad = true,
    this.errorLoadingMore = false,
    this.currentPage = 1,
    this.posts = const [],
  });

  PostState copyWith(
      {loading,
      failLoad,
      errorLoad,
      moreToLoad,
      errorLoadingMore,
      currentPage,
      posts}) {
    return PostState(
      loading: loading ?? this.loading,
      failLoad: failLoad ?? this.failLoad,
      errorLoad: errorLoad ?? this.errorLoad,
      moreToLoad: moreToLoad ?? this.moreToLoad,
      errorLoadingMore: errorLoadingMore ?? this.errorLoadingMore,
      currentPage: currentPage ?? this.currentPage,
      posts: posts ?? this.posts,
    );
  }

  dynamic toJson() => {
        'loading': loading,
        'failLoad': failLoad,
        'errorLoad': errorLoad,
        'moreToLoad': moreToLoad,
        'errorLoadingMore': errorLoadingMore,
        'currentPage': currentPage,
        'posts': posts,
      };

  @override
  String toString() {
    return 'PostState: ${JsonEncoder.withIndent('  ').convert(this)}';
  }
}
