import 'dart:convert';

class Shop {
  int id, accountRating;
  String name, about, logo, coverPhoto;
  bool followed;
  int nbOfFollowers, nbOfRatings, nbOfBranches;
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
		this.nbOfBranches,
	});

	factory Shop.fromJson(Map<String, dynamic> _json) {
		return Shop(
			id: _json['id'] as int,
			name: _json['name'] as String,
			about: _json['about'] as String,
			logo: _json['logo'] as String,
			coverPhoto: _json['cover_photo'] as String,
			nbOfBranches: _json['branches']?.length ?? 0,
			followed: _json.containsKey('followed')
				? _json['followed'] == 1 ? true : false
				: false,
			accountRating: _json['account_rating'] ?? 0,
			nbOfFollowers: _json['nb_of_followers'] ?? 0,
			nbOfRatings: _json['nb_of_ratings'] ?? 0,
			avgRating: _json['average_rating']?.toDouble() ?? 0,
		);
	}

	dynamic toJson() =>
		{
			'id': id,
			'name': name,
			'about': about,
			'logo': logo,
			'coverPhoto': coverPhoto,
			'nbOfBranches': nbOfBranches,
			'followed': followed,
		};

	@override
	String toString() {
		return JsonEncoder.withIndent('  ').convert(this);
	}
}
