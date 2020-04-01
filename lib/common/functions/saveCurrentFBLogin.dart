import 'package:shared_preferences/shared_preferences.dart';
import 'package:bigshop/models/json/fbloginModel.dart';

saveCurrentFBLogin(Map responseJson) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  var user;
  if((responseJson != null && responseJson.isNotEmpty)){
    user = FbLoginModel.fromJson(responseJson).fb_name;
  }else{
    user = "";
  }

  var fb_first_name = (responseJson != null && !responseJson.isEmpty) ? FbLoginModel.fromJson(responseJson).fb_first_name : "";
  var fb_last_name = (responseJson != null && !responseJson.isEmpty) ? FbLoginModel.fromJson(responseJson).fb_last_name : "";
  var fb_gender = (responseJson != null && !responseJson.isEmpty) ? FbLoginModel.fromJson(responseJson).fb_gender : "";
  var fb_birthday = (responseJson != null && !responseJson.isEmpty) ? FbLoginModel.fromJson(responseJson).fb_birthday : "";
  var fb_email = (responseJson != null && !responseJson.isEmpty) ? FbLoginModel.fromJson(responseJson).fb_email : "";
  var fb_picture = (responseJson != null && !responseJson.isEmpty) ? FbLoginModel.fromJson(responseJson).fb_picture : "";
  var fb_id = (responseJson != null && !responseJson.isEmpty) ? FbLoginModel.fromJson(responseJson).fb_id : "";

  await preferences.setString('LastUser', (user != null && user.length > 0) ? user : "");
  await preferences.setString('LastFirstName', (fb_first_name != null && fb_first_name.length > 0) ? fb_first_name : "");
  await preferences.setString('LastLastName', (fb_last_name != null && fb_last_name.length > 0) ? fb_last_name : "");
  await preferences.setString('LastGender', (fb_gender != null && fb_gender.length > 0) ? fb_gender : "");
  await preferences.setString('LastBirthday', (fb_birthday != null && fb_birthday.length > 0) ? fb_birthday : "");
  await preferences.setString('LastEmail', (fb_email != null && fb_email.length > 0) ? fb_email : "");
  await preferences.setString('LastPicture', (fb_picture != null && fb_picture.length > 0) ? fb_picture : "");
  await preferences.setString('LastId', (fb_id != null && fb_id.length > 0) ? fb_id : "");


}