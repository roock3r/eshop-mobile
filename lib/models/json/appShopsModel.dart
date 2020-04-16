import 'package:bigshop/models/json/appShopModel.dart';

class Shops {
  List<Shop> shop;

  Shops({this.shop});

  Shops.fromJson(Map<String, dynamic> json) {
    if (json['shop'] != null) {
      shop = new List<Shop>();
      json['shop'].forEach((v) {
        shop.add(new Shop.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shop != null) {
      data['shop'] = this.shop.map((v) => v.toJson()).toList();
    }
    return data;
  }
}