import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bigshop/common/providers/orders.dart' show Orders;
import 'package:bigshop/common/widgets/order_item.dart';


class OrdersPage extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
      ),
    );
  }
}
