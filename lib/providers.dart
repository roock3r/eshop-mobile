import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:bigshop/auth.dart';
import 'common/providers/cart.dart';
import 'common/providers/orders.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(
    create: (context) => AuthState(),
    lazy: false,
  ),
  ChangeNotifierProvider.value(
    value: Cart(),
  ),
  ChangeNotifierProvider.value(
    value: Orders(),
  ),
];
