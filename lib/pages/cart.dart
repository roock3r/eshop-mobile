import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:bigshop/common/providers/orders.dart';
//import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:bigshop/common/providers/cart.dart';
import 'package:bigshop/common/widgets/cart_item.dart' as ci;

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }



  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterOpenWhatsapp.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Close"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog emptyCartAlert = AlertDialog(
      title: Text("Empty Cart Notice"),
      content: Text("Kindly add an item to your cart so that you can place an order."),
      actions: [
        okButton,
      ],
    );

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget whatsappButton = FlatButton(
      child: Text("Whatsapp"),
      onPressed:  () {
        FlutterOpenWhatsapp.sendSingleMessage('${cart.currentShop.phone}',
            'Bigshop : ${cart.currentShop.name} '
            '\nItems Requested: Item id: ${cart.items.values.map((v) => v.itemId.toString())} Item: ${cart.items.values.map((v) => v.title.toString())} \n quantity: ${cart.items.values.map((v) => v.quantity.toString())} * Price: \$${cart.items.values.map((v) => v.price.toString())} '
            '\nTotal: \$${ cart.totalAmount }');
        cart.clear();
      },
    );
    Widget directButton = FlatButton(
      child: Text("Direct"),
      onPressed:  () {},
    );

    // set up the AlertDialog
    AlertDialog orderTypeAlert = AlertDialog(
      title: Text("Order Using ?"),
      content: Text("How do you wish to place your order ? Via Whatsapp or directly through the app ?"),
      actions: [
        cancelButton,
        whatsappButton,
        directButton,
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            tooltip: 'Clear Cart',
            onPressed: () {
              cart.clear();
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color:
                          Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: Text('ORDER NOW'),
                    onPressed: () {
                      if(cart.totalAmount > 0 ){
//                        Provider.of<Orders>(context, listen: false).addOrder(
//                          cart.items.values.toList(),
//                          cart.totalAmount,
//                        );
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return orderTypeAlert;
                          },
                        );
                      }else{
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return emptyCartAlert;
                          },
                        );
                      }
//                      Provider.of<Orders>(context, listen: false).addOrder(
//                        cart.items.values.toList(),
//                        cart.totalAmount,
//                      );
//                      for (CartItem me in cart.items.values){
//                        print('${me.id} ${me.itemId} ${me.shopId} ${me.title} ${me.quantity} ${me.price}');
//
//                      }
//                      cart.clear();
                    },
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => ci.CartItem(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
              ),
            ),
          )
        ],
      ),
    );
  }
}

//class CartPage extends StatelessWidget {
////  void whatsAppOpen() async {
////    bool whatsapp = await FlutterLaunch.hasApp(name: "whatsapp");
////
////    if(whatsapp) {
////      await FlutterLaunch.launchWathsApp(phone: '6533506', message: 'Testing');
////    }else {
////      print('No whatsapp installed.');
////    }
////  }
//
//  @override
//  Widget build(BuildContext context) {
//
//    // set up the button
//    Widget okButton = FlatButton(
//      child: Text("Close"),
//      onPressed: () {
//        Navigator.of(context).pop();
//      },
//    );
//
//    // set up the AlertDialog
//    AlertDialog emptyCartAlert = AlertDialog(
//      title: Text("Empty Cart Notice"),
//      content: Text("Kindly add an item to your cart so that you can place an order."),
//      actions: [
//        okButton,
//      ],
//    );
//
//    // set up the buttons
//    Widget cancelButton = FlatButton(
//      child: Text("Cancel"),
//      onPressed:  () {
//        Navigator.of(context).pop();
//      },
//    );
//    Widget whatsappButton = FlatButton(
//      child: Text("Whatsapp"),
//      onPressed:  () {
//
//      },
//    );
//    Widget directButton = FlatButton(
//      child: Text("Direct"),
//      onPressed:  () {},
//    );
//
//    // set up the AlertDialog
//    AlertDialog orderTypeAlert = AlertDialog(
//      title: Text("Order Using ?"),
//      content: Text("How do you wish to place your order ? Via Whatsapp or directly through the app ?"),
//      actions: [
//        cancelButton,
//        whatsappButton,
//        directButton,
//      ],
//    );
//
//
//    final cart = Provider.of<Cart>(context);
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Your Cart'),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.delete_forever),
//            tooltip: 'Clear Cart',
//            onPressed: () {
//              cart.clear();
//            },
//          )
//        ],
//      ),
//      body: Column(
//        children: <Widget>[
//          Card(
//            margin: EdgeInsets.all(15),
//            child: Padding(
//              padding: EdgeInsets.all(8),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Text(
//                    'Total',
//                    style: TextStyle(fontSize: 20),
//                  ),
//                  SizedBox(
//                    width: 10,
//                  ),
//                  Spacer(),
//                  Chip(
//                    label: Text(
//                      '\$${cart.totalAmount.toStringAsFixed(2)}',
//                      style: TextStyle(
//                          color:
//                          Theme.of(context).primaryTextTheme.title.color),
//                    ),
//                    backgroundColor: Theme.of(context).primaryColor,
//                  ),
//                  FlatButton(
//                    child: Text('ORDER NOW'),
//                    onPressed: () {
//                      if(cart.totalAmount > 0 ){
////                        Provider.of<Orders>(context, listen: false).addOrder(
////                          cart.items.values.toList(),
////                          cart.totalAmount,
////                        );
//                        showDialog(
//                          context: context,
//                          builder: (BuildContext context) {
//                            return orderTypeAlert;
//                          },
//                        );
//                      }else{
//                        showDialog(
//                          context: context,
//                          builder: (BuildContext context) {
//                            return emptyCartAlert;
//                          },
//                        );
//                      }
////                      Provider.of<Orders>(context, listen: false).addOrder(
////                        cart.items.values.toList(),
////                        cart.totalAmount,
////                      );
////                      for (CartItem me in cart.items.values){
////                        print('${me.id} ${me.itemId} ${me.shopId} ${me.title} ${me.quantity} ${me.price}');
////
////                      }
//                      cart.clear();
//                    },
//                    textColor: Theme.of(context).primaryColor,
//                  ),
//                ],
//              ),
//            ),
//          ),
//          SizedBox(
//            height: 10,
//          ),
//          Expanded(
//            child: ListView.builder(
//              itemCount: cart.items.length,
//              itemBuilder: (ctx, i) => ci.CartItem(
//                cart.items.values.toList()[i].id,
//                cart.items.keys.toList()[i],
//                cart.items.values.toList()[i].price,
//                cart.items.values.toList()[i].quantity,
//                cart.items.values.toList()[i].title,
//              ),
//            ),
//          )
//        ],
//      ),
//    );
//  }
//}
