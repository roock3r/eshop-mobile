import 'package:shared_preferences/shared_preferences.dart';
import 'package:bigshop/models/json/appLoginModel.dart';

saveCurrentAPPLogin(Map responseJson) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  var accessToken;
  if((responseJson != null && responseJson.isNotEmpty)){
    accessToken = AppLoginModel.fromJson(responseJson).accessToken;
  }else{
    accessToken = "";
  }

  var expires_in = (responseJson != null && !responseJson.isEmpty) ? AppLoginModel.fromJson(responseJson).expires_in : "";
  var token_type = (responseJson != null && !responseJson.isEmpty) ? AppLoginModel.fromJson(responseJson).token_type : "";
  var scope = (responseJson != null && !responseJson.isEmpty) ? AppLoginModel.fromJson(responseJson).scope : "";
  var refresh_token = (responseJson != null && !responseJson.isEmpty) ? AppLoginModel.fromJson(responseJson).refresh_token : "";

  await preferences.setString('LastAccessToken', (accessToken != null && accessToken.length > 0) ? accessToken : "");
  await preferences.setInt('LastExpireIn', (expires_in != null ) ? expires_in : 1200 );
  await preferences.setString('LastTokenType', (token_type != null && token_type.length > 0) ? token_type : "");
  await preferences.setString('LastScope', (scope != null && scope.length > 0) ? scope : "");
  await preferences.setString('LastRefreshToken', (refresh_token != null && refresh_token.length > 0) ? refresh_token : "");








}