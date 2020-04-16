import 'package:flutter/material.dart';
import 'package:bigshop/models/json/appShopItemModel.dart';

class CartItem {
  final String id;
  final String title;
  final String price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
  });
}

class CartBloc with ChangeNotifier {

  Map<int, int> _cart = {};

  Map<int, int> get cart => _cart;

  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addToCart(index,String productId, String price, String title) {
    if (_cart.containsKey(index)) {
      _cart[index] += 1;

      _items.update(
        productId,
            (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
        ),
      );

    } else {
      _cart[index] = 1;
      _items.putIfAbsent(
        productId,
            () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void clear(index) {
    if (_cart.containsKey(index)) {
      _cart.remove(index);
      notifyListeners();
    }
  }
}