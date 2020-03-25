import 'dart:convert';

class Branch {
  int id, shopId;
  String name, phone;
  double cdx, cdy;

  Branch({this.id, this.shopId, this.name, this.phone, this.cdx, this.cdy});

  factory Branch.fromJson(Map<String, dynamic> _json) {
    return Branch(
      id: _json['id'] as int,
      shopId: _json['shop_id'] as int,
      name: _json['name'] as String,
      phone: _json['phone'] as String,
      cdx: double.parse(_json['cdx'].toString()),
      cdy: double.parse(_json['cdy'].toString()),
    );
  }

  dynamic toJson() => {
        'id': id,
        'shopId': shopId,
        'name': name,
        'phone': phone,
        'cdx': cdx,
        'cdy': cdy,
      };

  @override
  String toString() {
    return JsonEncoder.withIndent('  ').convert(this);
  }
}
