import 'package:shared_preferences/shared_preferences.dart';

getToken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String getToken = await preferences.getString("LastAccessToken");
  return getToken;
}