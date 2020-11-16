import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bigshop/auth.dart';
import 'package:bigshop/providers.dart';

import 'package:bigshop/pages/home.dart';
import 'package:bigshop/pages/welcomePage.dart';
import 'package:bigshop/routes.dart';



void main() => runApp(BigShopApp());

class BigShopApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bigshop Belize',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Consumer<AuthState>(
          builder: (context, value, child) {
            return value.isLoggedIn ? HomePage() : WelcomePage();
          }
        ),
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
