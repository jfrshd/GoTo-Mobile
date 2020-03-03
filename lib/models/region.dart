import 'dart:ui';

class Region {
  final int id;
  final String name;
  final String svg;
  final Color color;
  bool selected;

  Region({this.id, this.name, this.svg, this.color, this.selected});

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
        id: json['id'] as int,
        name: json['name'] as String,
        svg: json['svg'] as String,
        color: Color.fromRGBO(
            int.parse((json['color'] as String).split(",")[0].trim()),
            int.parse((json['color'] as String).split(",")[1].trim()),
            int.parse((json['color'] as String).split(",")[2].trim()),
            double.parse((json['color'] as String).split(",")[3].trim())),
        selected: json['selected'] == 1 ? true : false);
  }
}
