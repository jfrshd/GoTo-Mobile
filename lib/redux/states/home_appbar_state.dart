import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class HomeState {
  final bool isSearch, isFilter, delayEnded, forceFocus;

//  final FocusNode focusNode = FocusNode();

  const HomeState({
    this.isSearch = false,
    this.isFilter = false,
    this.delayEnded = false,
    this.forceFocus = false,
  });

  HomeState copyWith({isSearch, isFilter, delayEnded, forceFocus}) {
    return HomeState(
      isSearch: isSearch ?? this.isSearch,
      isFilter: isFilter ?? this.isFilter,
      delayEnded: delayEnded ?? this.delayEnded,
      forceFocus: forceFocus ?? this.forceFocus,
    );
  }

  dynamic toJson() => {
        "isSearch": isSearch,
        "isFilter": isFilter,
        "delayEnded": delayEnded,
        "forceFocus": forceFocus,
      };

  @override
  String toString() {
    return 'HomeState: ${JsonEncoder.withIndent('  ').convert(this)}';
  }
}
