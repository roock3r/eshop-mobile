import 'package:shared_preferences/shared_preferences.dart';

getID() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String getID = await preferences.getString("LastId");
  return getID;
}