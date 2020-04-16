
//import 'package:bigshop/common/providers/cartBloc.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bigshop/common/providers/orders.dart';
import 'package:bigshop/common/providers/cart.dart';
import 'package:bigshop/common/widgets/cart_item.dart' as ci;
//
//class CartPage extends StatefulWidget {
//  @override
//  _CartPageState createState() => _CartPageState();
//}
//
//class _CartPageState extends State<CartPage> {
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
//}

//class CartPage extends StatelessWidget {
//  CartPage({Key key}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    var bloc = Provider.of<CartBloc>(context);
//    var cart = bloc.cart;
//    var item = bloc.items;
//    print('${item[1]}');
//
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Shopping Cart"),
//      ),
//      body: ListView.builder(
//        itemCount: cart.length,
//        itemBuilder: (context, index) {
//          int giftIndex = cart.keys.toList()[index];
//          int count = cart[giftIndex];
//          return ListTile(
//            leading: Container(
//              height: 70,
//              width: 70,
////              decoration: BoxDecoration(
////                image: DecorationImage(
////                  image: AssetImage("assets/${giftIndex + 1}.jpg"),
////                  fit: BoxFit.fitWidth,
////                ),
////                borderRadius: BorderRadius.circular(12),
////              ),
//            ),
//            title: Text('Item: ${item} Item Count: $count'),
//            trailing: RaisedButton(
//              child: Text('Clear'),
//              color: Theme.of(context).buttonColor,
//              elevation: 1.0,
//              splashColor: Colors.blueGrey,
//              onPressed: () {
//                bloc.clear(giftIndex);
//              },
//            ),
//          );
//        },
//      ),
//    );
//  }
//}

class CartPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
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
                      Provider.of<Orders>(context, listen: false).addOrder(
                        cart.items.values.toList(),
                        cart.totalAmount,
                      );
                      print(cart.items.values.toList());
//                      for (CartItem me in cart.items.values){
//                        print('${me.id} ${me.itemId} ${me.shopId} ${me.title} ${me.quantity} ${me.price}');
//
//                      }
//                      print('${cart.totalAmount}');
                      cart.clear();
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
