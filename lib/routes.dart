
import 'package:bigshop/pages/about.dart';
import 'package:flutter/material.dart';

import 'package:bigshop/pages/home.dart';
import 'package:bigshop/pages/item.dart';
import 'package:bigshop/pages/items.dart';
import 'package:bigshop/pages/orders.dart';

import 'package:bigshop/pages/signup.dart';
import 'package:bigshop/pages/loginPage.dart';
import 'package:bigshop/pages/welcomePage.dart';

import 'package:bigshop/models/json/appShopModel.dart';
import 'package:bigshop/models/json/appShopItemModel.dart';
import 'package:bigshop/pages/cart.dart';

class AppRoutes {

  static const String welcome = "welcome";
  static const String login = "login";
  static const String register = "register";
  static const String home = "home";
  static const String items = "items";
  static const String item_detail = "item";
  static const String cart = "cart";
  static const String orders = "orders";
  static const String about = "about";


  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
  int shopId;
  int itemId;
  String shopName;
  String itemName;
  Shop shop;
  Item item;
    return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          switch (settings.name) {
            case home:
              return HomePage();
            case items:
              return ItemsPage(shopId,shopName,shop);
            case item_detail:
              return ItemPage(itemId, itemName, shop, item);
            case cart:
              return CartPage();
            case orders:
              return OrdersPage();
            case about:
              return AboutPage();
            case login:
              return LoginPage();
            case register:
              return SignUpPage();
            case welcome:
            default:
              return WelcomePage();
          }
        });
  }
}