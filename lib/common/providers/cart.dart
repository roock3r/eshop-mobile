import 'package:flutter/cupertino.dart';
import 'package:bigshop/common/functions/getToken.dart';
import 'package:bigshop/models/json/appShopModel.dart';
import 'package:bigshop/models/json/appShopCartItemModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart with ChangeNotifier {

  int currentshopId;
  String currentshopPhone;
  String userToken;
  String userOrderType;
  String userPhoneNumber;
  String userAddress;

  Cart() {
//    setup();
    getToken().then((result) {
      userToken = result;
      notifyListeners();
    });
  }

//  void setup() async {
//    SharedPreferences preferences = await SharedPreferences.getInstance();
//    String _token = await preferences.getString("LastAccessToken");
//  }


  Shop currentShop;

  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, int shopId, String shopPhone, double price, String title, int qty, Shop shop) {
    if (currentshopId == null) {
      currentshopId = shopId;
      currentshopPhone = shopPhone;
      currentShop = shop;
      if (_items.containsKey(productId)) {
        //change quantity.....
        _items.update(
          productId,
              (existingCartItem) => CartItem(
            id: existingCartItem.id,
            itemId: existingCartItem.itemId,
            shopId: existingCartItem.shopId,
            title: existingCartItem.title,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity + ((qty > 1 ) ? qty : 1) ,
          ),
        );
      } else {
        _items.putIfAbsent(
          productId,
              () => CartItem(
            id: DateTime.now().toString(),
            itemId: productId,
            shopId: shopId,
            title: title,
            price: price,
            quantity: ((qty > 1 ) ? qty : 1),
          ),
        );
      }
    } else if ( currentshopId == shopId ) {
      if (_items.containsKey(productId)) {
        //change quantity.....
        _items.update(
          productId,
              (existingCartItem) => CartItem(
            id: existingCartItem.id,
            itemId: existingCartItem.itemId,
            shopId: existingCartItem.shopId,
            title: existingCartItem.title,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity + ((qty > 1 ) ? qty : 1),
          ),
        );
      } else {
        _items.putIfAbsent(
          productId,
              () => CartItem(
            id: DateTime.now().toString(),
            itemId: productId,
            shopId: shopId,
            title: title,
            price: price,
            quantity: ((qty > 1 ) ? qty : 1),
          ),
        );
      }
    } else if (shopId != shopId) {
      return null;
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    currentshopId = null;
    currentshopPhone = null;
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId ,int qty) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
              (existingCartItem) => CartItem(
            id: existingCartItem.id,
            itemId: existingCartItem.itemId,
            shopId: existingCartItem.shopId,
            title: existingCartItem.title,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity - ((qty > 1 ) ? qty : 1),
          ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  Map<String, dynamic> toJson() => {
    "access_token": userToken,
    "restaurant_id": currentshopId,
    "phone": userPhoneNumber,
    "order_type": userOrderType,
    "address": userAddress,
    "order_details": List<dynamic>.from(items.values.map((x) => x.toJson())),
  };

}