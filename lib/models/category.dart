class Category {
  final int id;
  final String name;
  final String thumbnail;
  bool selected;

  Category({this.id, this.name, this.thumbnail, this.selected});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      thumbnail: json['thumbnail'] as String,
      selected: json['selected'] == 1 ? true : false,
    );
  }
}
