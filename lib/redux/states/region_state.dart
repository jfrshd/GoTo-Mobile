import 'dart:convert';

import 'package:gotomobile/models/region.dart';
import 'package:meta/meta.dart';

@immutable
class RegionState {
  final bool loading, failLoad, errorLoad;
  final bool updating, failUpdate, errorUpdate;
  final List<Region> regions;

  const RegionState({
    this.loading = false,
    this.failLoad = false,
    this.errorLoad = false,
    this.updating = false,
    this.failUpdate = false,
    this.errorUpdate = false,
    this.regions = const [],
  });

  RegionState copyWith(
      {loading,
      failLoad,
      errorLoad,
      updating,
      failUpdate,
      errorUpdate,
      regions}) {
    return RegionState(
      loading: loading ?? this.loading,
      failLoad: failLoad ?? this.failLoad,
      errorLoad: errorLoad ?? this.errorLoad,
      updating: updating ?? this.updating,
      failUpdate: failUpdate ?? this.failUpdate,
      errorUpdate: errorUpdate ?? this.errorUpdate,
      regions: regions ?? this.regions,
    );
  }

  dynamic toJson() => {
        'loading': loading,
        'failLoad': failLoad,
        'errorLoad': errorLoad,
        'updating': updating,
        'failUpdate': failUpdate,
        'errorUpdate': errorUpdate,
        'regions': regions,
      };

  @override
  String toString() {
    return 'RegionState: ${JsonEncoder.withIndent('  ').convert(this)}';
  }
}
