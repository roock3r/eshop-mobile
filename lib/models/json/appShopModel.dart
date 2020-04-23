class Shop {
  int id;
  String name;
  String phone;
  String address;
  int location;
  String location_info;
  String location_type;
  int district;
  String district_info;
  String logo;
  int index;

  Shop({this.id, this.name, this.phone, this.address, this.logo});

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    location = json['location'];
    location_info = json['location_info'];
    location_type = json['location_type'];
    district = json['district'];
    district_info = json['district_info'];
    logo = json['logo'];
    index = json['restaurant_index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['location'] = this.location;
    data['location_info'] = this.location_info;
    data['location_type'] = this.location_type;
    data['district'] = this.district;
    data['district_info'] = this.district_info;
    data['logo'] = this.logo;
    data['restaurant_index'] = this.index;
    return data;
  }
}