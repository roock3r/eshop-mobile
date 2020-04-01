class FbLoginModel {
  final String fb_name;
  final String fb_first_name;
  final String fb_last_name;
  final String fb_gender;
  final String fb_birthday;
  final String fb_email;
  final String fb_picture;
  final String fb_id;

  FbLoginModel(this.fb_name,this.fb_first_name,this.fb_last_name,this.fb_gender,this.fb_birthday,this.fb_email,this.fb_picture,this.fb_id);

  FbLoginModel.fromJson(Map<String, dynamic> json)
      : fb_name = json['name'],
        fb_first_name = json['first_name'],
        fb_last_name = json['last_name'],
        fb_gender = json['gender'],
        fb_birthday = json['birthday'],
        fb_email = json['email'],
        fb_picture = json['picture']['data']['url'],
        fb_id = json['id'];

  Map<String, dynamic> toJson() =>
      {
        'name':fb_name,
        'first_name':fb_first_name,
        'last_name':fb_last_name,
        'gender':fb_gender,
        'birthday':fb_birthday,
        'email':fb_email,
        'picture':fb_picture,
        'id':fb_id,
      };

}
