import 'dart:convert';

class Filter {
  final int id;
  final String title;
  bool selected;

  Filter({this.id = -1, this.title = '', this.selected = false});

  dynamic toJson() => {
        'title': title,
        'selected': selected ? 1 : 0,
      };

  @override
  String toString() {
    return JsonEncoder.withIndent('  ').convert(this);
  }
}
