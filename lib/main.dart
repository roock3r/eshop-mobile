import 'package:bigshop/models/json/appShopModel.dart';
import 'package:bigshop/pages/cart.dart';
import 'package:bigshop/pages/home.dart';
import 'package:bigshop/pages/item.dart';
import 'package:bigshop/pages/items.dart';
import 'package:bigshop/pages/orders.dart';
import 'package:bigshop/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:bigshop/pages/login.dart';
import 'package:provider/provider.dart';

import 'common/providers/cart.dart';
import 'common/providers/orders.dart';
import 'models/json/appShopItemModel.dart';

void main() => runApp(BigShopApp());

class BigShopApp extends StatelessWidget {
  int shopId;
  int itemId;
  String shopName;
  String itemName;
  Shop shop;
  Item item;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Big Shop Belize',
        routes: <String, WidgetBuilder>{
          "/loginScreen": (BuildContext context) => LoginPage(),
          "/home": (BuildContext context) => HomePage(),
          "/items": (BuildContext context) => ItemsPage(shopId,shopName,shop),
          "/item": (BuildContext context) => ItemPage(itemId,itemName,shop,item),
          "/cart": (BuildContext context) => CartPage(),
          "/orders": (BuildContext context) => OrdersPage(),
          "/splash": (BuildContext context) => SplashPage(),
        },
        home: LoginPage(),
      ),
    );
  }
}
