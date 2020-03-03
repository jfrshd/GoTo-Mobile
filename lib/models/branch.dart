class Branch {
  int id, shopId;
  String name, phone;
  int cdx, cdy;

  Branch({this.id, this.shopId, this.name, this.phone, this.cdx, this.cdy});

  factory Branch.fromJson(Map<String, dynamic> _json) {
    return Branch(
      id: _json['id'] as int,
      shopId: _json['shop_id'] as int,
      name: _json['name'] as String,
      phone: _json['phone'] as String,
      cdx: _json['cdx'],
      cdy: _json['cdy'],
    );
  }
}
