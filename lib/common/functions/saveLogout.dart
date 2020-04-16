import 'package:shared_preferences/shared_preferences.dart';

saveLogout() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  await preferences.setString('LastUser', "");
  await preferences.setString('LastFirstName', "");
  await preferences.setString('LastLastName', "");
  await preferences.setString('LastGender', "");
  await preferences.setString('LastBirthday', "");
  await preferences.setString('LastEmail', "");
  await preferences.setString('LastPicture', "");
  await preferences.setString('LastId', "");
  await preferences.setString('LastAccessToken', "");
  await preferences.setString('LastExpireIn', "");
  await preferences.setString('LastTokenType', "");
  await preferences.setString('LastScope', "");
  await preferences.setString('LastRefreshToken', "");
}