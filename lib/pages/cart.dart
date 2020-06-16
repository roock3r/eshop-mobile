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
  TextEditingController address;
  TextEditingController phone;

  @override
  void initState() {
    address = new TextEditingController();
    phone = new TextEditingController();
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
            "\nTotal: \$${cart.totalAmount}";
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

    _textInputDialog(BuildContext context) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Enter Address and Phone'),
              content: Column(
                children: <Widget>[
                  new Expanded(
                    child: new TextField(
                      autofocus: true,
                      keyboardType: TextInputType.multiline,
                      decoration: new InputDecoration(
                          labelText: 'Home Address',
                          hintText: 'eg. # 5982 Raccoon Street, Belize City',
                          suffixIcon: Icon(Icons.home)),
                      controller: address,
                    ),
                  ),
                  new Expanded(
                    child: new TextField(
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      decoration: new InputDecoration(
                          labelText: 'Phone Number',
                          hintText: 'eg. 5016660000',
                          suffixIcon: Icon(Icons.phone)),
                      controller: phone,
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                cancelButton,
                new FlatButton(
                  child: new Text('Submit & Continue'),
                  onPressed: () {
                    setState(() {
                      cart.userAddress = address.text;
                      cart.userPhoneNumber = phone.text;
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }

    Widget whatsappButton = FlatButton(
      child: Text("WhatsApp"),
      onPressed: () {
        String cartToJson(Cart cart) => json.encode(cart.toJson());
        print(cartToJson(cart));
        launchWhatsAppCart();
        //cart.clear();
      },
    );

    Widget directButton = FlatButton(
      child: Text("Direct"),
      onPressed: () {
        Navigator.of(context).pop();
        _textInputDialog(context);
//        _showDialog() async {
//          await
//          Navigator.of(context).pop();
//          showDialog<String>(
//            context: context,
//            child: new _SystemPadding(child: new AlertDialog(
//              contentPadding: const EdgeInsets.all(16.0),
//              content: new Row(
//                children: <Widget>[
//                  new Expanded(
//                    child: new TextField(
//                      autofocus: true,
//                      decoration: new InputDecoration(
//                          labelText: 'Home Address', hintText: 'eg. # 5982 Raccoon Street, Belize City'),
//                      controller: address,
//                    ),
//                  ),
//                  new Expanded(
//                    child: new TextField(
//                      autofocus: true,
//                      decoration: new InputDecoration(
//                          labelText: 'Phone Number', hintText: 'eg. 5016660000'),
//                      controller: phone,
//                    ),
//                  ),
//                ],
//              ),
//              actions: <Widget>[
//                new FlatButton(
//                    child: const Text('CANCEL'),
//                    onPressed: () {
//                      Navigator.pop(context);
//                    }),
//                new FlatButton(
//                    child: const Text('OPEN'),
//                    onPressed: () {
//                      Navigator.pop(context);
//                    })
//              ],
//            ),),
//          );
//        }

//        showDialog(
//            child: new Dialog(
//              shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(12.0),
//              ),
//              child: Container(
//                decoration: BoxDecoration(
//                  borderRadius: BorderRadius.circular(20.0),
//                ),
//                height: 300.0,
//                width: 300.0,
//                child: Stack(
//                  children: <Widget>[
//                    Container(
//                      width: double.infinity,
//                      height: 300,
//                      decoration: BoxDecoration(
//                        color: Colors.grey[100],
//                        borderRadius: BorderRadius.circular(12.0),
//                      ),
//                    ),
//                    Container(
//                      width: double.infinity,
//                      height: 50,
//                      alignment: Alignment.bottomCenter,
//                      decoration: BoxDecoration(
//                        color: Colors.greenAccent,
//                        borderRadius: BorderRadius.only(
//                          topLeft: Radius.circular(12),
//                          topRight: Radius.circular(12),
//                        ),
//                      ),
//                      child: Align(
//                        alignment: Alignment.center,
//                        child: Text(
//                          "Set address and phone!",
//                          style: TextStyle(
//                              color: Colors.white,
//                              fontSize: 20,
//                              fontWeight: FontWeight.w600),
//                        ),
//                      ),
//                    ),
//                    Align(
//                      alignment: Alignment.bottomCenter,
//                      child: InkWell(
//                        onTap: () {
//                          Navigator.pop(context);
//                        },
//                        child: Container(
//                          width: double.infinity,
//                          height: 50,
//                          decoration: BoxDecoration(
//                            color: Colors.blue[300],
//                            borderRadius: BorderRadius.only(
//                              bottomLeft: Radius.circular(12),
//                              bottomRight: Radius.circular(12),
//                            ),
//                          ),
//                          child: Align(
//                            alignment: Alignment.center,
//                            child: Text(
//                              "Okay let's go! ",
//                              style: TextStyle(
//                                  color: Colors.white,
//                                  fontSize: 20,
//                                  fontWeight: FontWeight.w600),
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                    Align(
//                      // These values are based on trial & error method
//                      alignment: Alignment(1.05, -1.05),
//                      child: InkWell(
//                        onTap: () {
//                          Navigator.pop(context);
//                        },
//                        child: Container(
//                          decoration: BoxDecoration(
//                            color: Colors.grey[200],
//                            borderRadius: BorderRadius.circular(12),
//                          ),
//                          child: Icon(
//                            Icons.close,
//                            color: Colors.black,
//                          ),
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//            ),


//            child: new Dialog(
//
//              child: new Column(
//                children: <Widget>[
//                  new TextField(
//                    decoration:
//                        new InputDecoration(hintText: "Add Address for Order"),
//                    controller: address,
//                  ),
//                  new TextField(
//                    decoration: new InputDecoration(
//                        hintText: "Add a Phone Number for Order"),
//                    controller: phone,
//                  ),
//                  new FlatButton(
//                    child: new Text("Save"),
//                    onPressed: () {
//                      setState(() {
//                        cart.userAddress = address.text;
//                        cart.userPhoneNumber = phone.text;
//                      });
//                      Navigator.pop(context);
//                    },
//                  )
//                ],
//              ),
//            ),
            //context: context);
      },
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
      //Add dialog to ask for users address and phone number for submission via
      //The API
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
