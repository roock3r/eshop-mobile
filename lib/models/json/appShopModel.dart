class Shop {
  int id;
  String name;
  String phone;
  String address;
  String logo;

  Shop({this.id, this.name, this.phone, this.address, this.logo});

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['logo'] = this.logo;
    return data;
  }
}