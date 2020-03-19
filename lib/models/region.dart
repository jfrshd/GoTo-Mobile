import 'dart:convert';
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

  dynamic toJson() => {
        'id': id,
        'name': name,
        'svg': svg,
        'color': color.red.toString() +
            "," +
            color.green.toString() +
            "," +
            color.blue.toString() +
            "," +
            (color.alpha / 255).toString(),
        'selected': selected ? 1 : 0,
      };

  @override
  String toString() {
    return JsonEncoder.withIndent('  ').convert(this);
  }
}
