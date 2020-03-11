class Shop {
  int id, accountRating;
  String name, about, logo, coverPhoto;
  bool followed;
  int nbOfFollowers, nbOfRatings;
  double avgRating;

  Shop({
    this.id,
    this.name,
    this.about,
    this.logo,
    this.coverPhoto,
    this.followed,
    this.accountRating,
    this.nbOfFollowers,
    this.nbOfRatings,
    this.avgRating,
  });

  factory Shop.fromJson(Map<String, dynamic> _json) {
    return Shop(
		id: _json['id'] as int,
		name: _json['name'] as String,
		about: _json['about'] as String,
		logo: _json['logo'] as String,
		coverPhoto: _json['cover_photo'] as String,
		followed: _json.containsKey('followed')
			? _json['cover_photo'] == 1 ? true : false
			: false,
		accountRating:
		_json.containsKey('account_rating') ? _json['account_rating'] : 0,
		nbOfFollowers:
		_json.containsKey('nb_of_followers') ? _json['nb_of_followers'] : 0,
		nbOfRatings:
		_json.containsKey('nb_of_ratings') ? _json['nb_of_ratings'] : 0,
		avgRating: _json.containsKey('average_rating')
			? _json['average_rating'].toDouble()
			: 0,
    );
  }
}
