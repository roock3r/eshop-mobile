import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:bigshop/common/providers/orders.dart';

import 'package:bigshop/common/providers/cart.dart';
import 'package:bigshop/common/widgets/cart_item.dart' as ci;
import 'package:url_launcher/url_launcher.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
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

    void launchWhatsAppCart({
      @required String phone,
      @required String message,
    }) async {
      String url() {
        phone = cart.currentShop.phone;
        message =
            "Bigshop Ref: \nHi ${cart.currentShop.name} I would like to order the following items\n"
                "Items Requested: Item id: ${cart.items.values.map((v) => v.itemId.toString())} Item: ${cart.items.values.map((v) => v.title.toString())} \nQuantity: ${cart.items.values.map((v) => v.quantity.toString())} * Price: \$${cart.items.values.map((v) => v.price.toString())}"
                "\nTotal: \$${ cart.totalAmount }";
        if (Platform.isIOS) {
          return "whatsapp://wa.me/${cart.currentShop.phone}/?text=${Uri.encodeFull(message)}";
        } else {
          return "whatsapp://send?phone=${cart.currentShop.phone}&text=${Uri.encodeFull(message)}";
        }
      }

      if (await canLaunch(url())) {
        await launch(url());
      } else {
        throw 'Could not launch ${url()}';
      }
    }

    // set up the AlertDialog
    AlertDialog emptyCartAlert = AlertDialog(
      title: Text("Empty Cart Notice"),
      content: Text(
          "Kindly add an item to your cart so that you can place an order."),
      actions: [
        okButton,
      ],
    );

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget whatsappButton = FlatButton(
      child: Text("WhatsApp"),
      onPressed: () {
//          whatsAppOpen();
//        FlutterLaunch.launchWathsApp(phone: "${cart.currentShop.phone}", message: "test");

        //IPhone
//        FlutterLaunch.launchWathsApp(phone: "${cart.currentShop.phone}", message: "Bigshop : ${cart.currentShop.name} "
//            "\nItems Requested: Item id: ${cart.items.values.map((v) => v.itemId.toString())} Item: ${cart.items.values.map((v) => v.title.toString())} \nQuantity: ${cart.items.values.map((v) => v.quantity.toString())} * Price: \$${cart.items.values.map((v) => v.price.toString())} "
//            "\nTotal: \$${ cart.totalAmount }");

//        //Android
//        FlutterOpenWhatsapp.sendSingleMessage('${cart.currentShop.phone}',
//            'Bigshop : ${cart.currentShop.name} '
//            '\nItems Requested: Item id: ${cart.items.values.map((v) => v.itemId.toString())} Item: ${cart.items.values.map((v) => v.title.toString())} \nQuantity: ${cart.items.values.map((v) => v.quantity.toString())} * Price: \$${cart.items.values.map((v) => v.price.toString())} '
//            '\nTotal: \$${ cart.totalAmount }');
        String cartToJson(Cart cart) => json.encode(cart.toJson());
        print(cartToJson(cart));
        launchWhatsAppCart();
        //cart.clear();
      },
    );
    Widget directButton = FlatButton(
      child: Text("Direct"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog orderTypeAlert = AlertDialog(
      title: Text("Order Using ?"),
      content: Text(
          "How do you wish to place your order ? Via WhatsApp or directly through the app ?"),
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
                      if (cart.totalAmount > 0) {
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
                      } else {
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
