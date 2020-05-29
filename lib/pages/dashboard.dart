import 'package:bigshop/common/apifunctions/requestShopsAPI.dart';
import 'package:bigshop/common/widgets/pleaseWaitWidget.dart';
import 'package:bigshop/models/json/appShopModel.dart';
import 'package:flutter/material.dart';

import 'package:bigshop/models/json/appShopModel.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

import 'cart.dart';
import 'items.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PleaseWaitWidget _pleaseWaitWidget = PleaseWaitWidget(key: ObjectKey("pleaseWaitWidget"));

  bool _refresh = true;
  List<Shop> _shops;
  bool _pleaseWait = false;

  _showSnackBar(String content, {bool error = false}){
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content:
      Text('${error ? "An unexpected error occured: " : ""}${content}'),
    ));
  }

  _showPleaseWait(bool b){
    setState(() {
      _pleaseWait = b;
    });
  }


  _refreshShops(){
    setState(() {
      _refresh = true;
    });
  }

  _navigateToShop(BuildContext context, int shopId, String shopName, Shop shop){
    Navigator.push(context,
      MaterialPageRoute(builder: (context) => ItemsPage(shopId,shopName,shop)),
    ).then((result) {
      if((result != null) && (result is bool) && (result == true)){
        _showSnackBar('Shop saved');
        _refreshShops();
      }
    });
  }

  badStatusCode(Response response){
    debugPrint("Bad status code ${response.statusCode} returned from server.");
    debugPrint("Response body ${response.body} returned from server.");
    throw Exception('Bad status code ${response.statusCode} returned from server.');
  }


  _loadShops(BuildContext context){
    _showPleaseWait(true);
    try{
      requestShopAPI.loadAndParseShops().then((response){
        setState(() {
          if(response.statusCode == 200){
            final list = json.decode(response.body);
            var shops = list['restaurants'].map<Shop>((json) => Shop.fromJson(json)).toList();
            _shops = shops;
          }else{
            badStatusCode(response);
          }
        });
        _showPleaseWait(false);

      }).catchError((error){
        _showPleaseWait(false);
        _showSnackBar(error.toString(), error: true);
      });
    } catch (e) {
      _showPleaseWait(false);
      _showSnackBar(e.toString(), error: true);
    }
  }
  @override
  Widget build(BuildContext context) {
    if(_refresh){
      _refresh = false;
      _loadShops(context);
    }


    ListView builder = ListView.builder(
        itemCount: _shops != null ? _shops.length : 0,
        itemBuilder: (context, index) {
          Shop shop = _shops[index];
          return ListTile(
            leading:  Image.network(shop.logo),
            title: Text('${shop.name}'),
            subtitle: Text('Address: ${shop.address} , Location: ${shop.location_info}, District: ${shop.district_info}'),
            trailing: Icon(Icons.arrow_right),
            onTap: () => _navigateToShop(context, shop.id, shop.name, shop),
            isThreeLine: true,
//            onLongPress: () => _deleteEmployee(context, employee),
          );
        });
    Widget bodyWidget = _pleaseWait ? Stack(key: ObjectKey("stack"),children: <Widget>[_pleaseWaitWidget, builder],): Stack(key: ObjectKey("stack"),children: [builder]);

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("Shops"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              _refreshShops();
            },
          )
        ],
      ),
      body: new Center( child: bodyWidget),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> CartPage()));
        },
        tooltip: 'Cart',
        child: Icon(Icons.shopping_basket),
      ),
    );
  }
}