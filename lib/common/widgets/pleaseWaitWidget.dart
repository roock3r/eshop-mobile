import 'package:flutter/material.dart';

class PleaseWaitWidget extends StatelessWidget {
  PleaseWaitWidget({
    Key key,
  }):super(key: key);

  // This widget is the roof of your application
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
        color: Colors.white.withOpacity(0.8)
    );
  }
}