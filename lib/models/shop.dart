class Shop {
  int id;
  String name, about, logo, coverPhoto;

  Shop({
    this.id,
    this.name,
    this.about,
    this.logo,
    this.coverPhoto,
  });

  factory Shop.fromJson(Map<String, dynamic> _json) {
    return Shop(
      id: _json['id'] as int,
      name: _json['name'] as String,
      about: _json['about'] as String,
      logo: _json['logo'] as String,
      coverPhoto: _json['cover_photo'] as String,
    );
  }
}
