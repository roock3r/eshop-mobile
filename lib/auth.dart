import 'dart:convert';
import 'dart:io';
// import 'package:bigshop/functions/helpers/getToken.dart';
// import 'package:cobalt_blue/functions/saveCurrentToken.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:bigshop/res/constants.dart';
import 'package:bigshop/models/json/User.dart';
import 'package:bigshop/models/json/Token.dart';

class AuthState extends ChangeNotifier {
  bool _isLoggedIn;
  bool _tokenStatus;
  User _user;
  String _error;
  String _token;

  bool get isLoggedIn => _isLoggedIn;
  User get user => _user;
  String get error => _error;
  String get token => _token;

  AuthState() {
    _init();
  }

  _init() {
    _isLoggedIn = false;
    _user = null;
    _token = null;
    _checkIsLoggedIn();
  }

  // Future<bool> _verifyToken(String token) async {
  //   var verificationUrl = AppConstants.apiRoute + "verify/";
  //   try {
  //     Map<String, String> body = {
  //       'token': "${token}",
  //     };
  //     var res = await http.post(
  //       verificationUrl,
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode(body),
  //     );
  //     if (res.statusCode == 200) {
  //       return Future.value(true);
  //     } else if (res.statusCode == 400){
  //       return Future.value(false);
  //     }else if (res.statusCode == 401){
  //       return Future.value(false);
  //     } else{
  //       throw ('Did not respond properly');
  //       badStatusCode(res);
  //     }
  //   } catch (e) {
  //     throw (e);
  //   }
  // }

  Future<User> _getAccount(String token) async {
    var userUrl = AppConstants.apiRoute + "me/";
    try {
      final dynamic res = await http.get(
        userUrl,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
      );
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        return User.fromJson(body['user']);
      } else {
        badStatusCode(res);
      }
    } catch (e) {
      throw (e);
    }
  }

  _checkIsLoggedIn() async {
    try {
      // _tokenStatus = _verifyToken(_token);
      // print(_token);
      _user = await _getAccount(_token);
      print(_token);
      _isLoggedIn = true;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }


  logout() async {
    try {
      // Response res = await account.deleteSession(sessionId: 'current');
      _token = null;
      _isLoggedIn = false;
      _user = null;
      notifyListeners();
    } catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }

  Future<dynamic> login(String username, String password) async {
    final loginUrl = AppConstants.apiRoute + "token/";
    try {
      Map<String, String> body = {
        'username': "${username}",
        'password': "${password}",
      };

      var result = await http.post(
        loginUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (result.statusCode == 200) {
        final response = json.decode(result.body);
        _token = Token.fromJson(response).access;
        _isLoggedIn = true;
        _user = await _getAccount(_token);
        notifyListeners();
        return json.decode(response);
      }else{
        badStatusCode(result);
      }
    } catch (e) {
       throw (e.toString());
    }
  }

  Future<dynamic> createAccount(String username, String password, String email, String firstName, String lastName) async {
    final registerUrl = AppConstants.apiRoute + "register/";
    try {
      Map<String, String> body = {
        'username': "${username}",
        'password':"${password}",
        'email': "${email}",
        'first_name':"${firstName}",
        'last_name':"${lastName}"
      };
      var result = await http.post(registerUrl, headers: {'Content-Type': 'application/json'}, body: json.encode(body) );
      if (result.statusCode == 200) {
        final response = json.decode(result.body);
        notifyListeners();
        return response;
      }else{
        badStatusCode(result);
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  badStatusCode(Response response){
    debugPrint("Bad status code ${response.statusCode} returned from server.");
    debugPrint("Response body ${response.body} returned from server.");
    throw ('Bad status code ${response.statusCode} with message: ${response.body} returned from server.');
  }
}