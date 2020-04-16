class Item {
  int id;
  String name;
  String shortDescription;
  String image;
  double price;

  Item({this.id, this.name, this.shortDescription, this.image, this.price});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortDescription = json['short_description'];
    image = json['image'];
    price = double.parse(json['price']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['short_description'] = this.shortDescription;
    data['image'] = this.image;
    data['price'] = this.price;
    return data;
  }
}