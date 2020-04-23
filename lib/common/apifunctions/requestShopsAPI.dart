import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:bigshop/models/json/appShopModel.dart';

class requestShopAPI extends InheritedWidget {
  static final String _BASE_URL = "https://bigshop.silvatech.org/api/customer/";
  static const _TIMEOUT = Duration(seconds: 10);

  requestShopAPI({
    Key key,
    @required Widget child,
  }) : assert(child != null),super(key: key, child: child);

  static requestShopAPI of(BuildContext context){
    return context.inheritFromWidgetOfExactType(requestShopAPI) as requestShopAPI;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget){
    return false;
  }

//  Future<List<Shop>> loadAndParseShops() async{
//    var url = '${_BASE_URL}/shop';
//    final response = await http.get(url).timeout(_TIMEOUT);
//    if(response.statusCode == 200){
//      final parsed = json.decode(response.body);
//      var list = parsed['restaurants'].map<Shop>((json) => Shop.fromJson(json)).toList();
//      return list;
//    }else{
//      badStatusCode(response);
//    }
//  }
  static Future loadAndParseShops() {
    var url = '${_BASE_URL}/shops';
    return http.get(url);
  }

  badStatusCode(Response response){
    debugPrint("Bad status code ${response.statusCode} returned from server.");
    debugPrint("Response body ${response.body} returned from server.");
    throw Exception('Bad status code ${response.statusCode} returned from server.');
  }
}

//const baseUrl = "https://bigshop.silvatech.org/api/customer/";
//
//
//class requestShopAPI {
//  static Future loadAndParseShops() {
//    var url = baseUrl + "/shop";
//    return http.get(url);
//  }
//}

