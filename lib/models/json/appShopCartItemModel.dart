import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final String itemId;
  final int shopId;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.itemId,
    @required this.shopId,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}